// lib/screens/payments/payment_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/api_service.dart';
import '../../utils/theme.dart';

class PaymentScreen extends StatefulWidget {
  final int bookingId;
  final double? amount;
  final bool isWalletRecharge;
  
  const PaymentScreen({
    Key? key, 
    required this.bookingId,
    this.amount,
    this.isWalletRecharge = false,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  final ApiService _api = ApiService();
  bool _loading = false;
  String? _orderId;
  String? _keyId;
  int? _amountPaise;
  int? _paymentInternalId;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _initiateAndOpenCheckout() async {
    setState(() => _loading = true);
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final token = await userProv.auth.getToken();

    // Call backend to create order
    final resp = await _api.post('/api/payments/initiate/', {'booking_id': widget.bookingId}, token: token);
    setState(() => _loading = false);

    if (resp == null || resp['order_id'] == null) {
      final err = resp != null ? resp.toString() : 'Unknown error';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment initiation failed: $err')));
      return;
    }

    // Extract response
    _orderId = resp['order_id'].toString();
    _keyId = resp['key']?.toString() ?? '';
    _paymentInternalId = resp['payment_id_internal'] ?? resp['payment_id_internal'];

    // amount may be provided as paise; if not, we use provided 'amount' or 0
    final rawAmount = resp['amount'];
    int amountPaise = 0;
    if (rawAmount is int) {
      amountPaise = rawAmount;
    } else if (rawAmount is String) {
      // sometimes returned as "1500" meaning paise or 15.00? we'll try best effort
      amountPaise = int.tryParse(rawAmount) ?? 0;
    } else if (rawAmount is double) {
      amountPaise = (rawAmount).toInt();
    } else {
      // fallback 0
      amountPaise = 0;
    }
    _amountPaise = amountPaise;

    // Prepare checkout options
    final options = {
      'key': _keyId ?? '',
      // If you have a real order_id (recommended), use it
      if (_orderId != null) 'order_id': _orderId,
      'amount': _amountPaise ?? 0, // amount in paise
      'name': 'Pandittalk',
      'description': 'Consultation booking',
      'prefill': {
        'contact': '', // optionally fill with user phone
        'email': ''    // optionally fill with user email
      },
      'theme': {
        'color': '#FFA500' // saffron
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Checkout error: ${e.toString()}')));
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // response.paymentId, response.orderId, response.signature
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment success! Verifying...')));
    // send verification to backend
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final token = await userProv.auth.getToken();
    final payload = {
      'payment_id_internal': _paymentInternalId,
      'order_id': response.orderId,
      'payment_id': response.paymentId,
      'signature': response.signature
    };
    final verifyResp = await _api.post('/api/payments/verify/', payload, token: token);
    if (verifyResp != null && verifyResp['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment verified — booking confirmed.')));
      // Optionally navigate back or to booking summary
      Navigator.of(context).pop(); // go back to previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment verification failed.')));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: ${response.message}')));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('External wallet selected: ${response.walletName}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: AppTheme.saffron,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Pay for booking #${widget.bookingId}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loading ? null : _initiateAndOpenCheckout,
              icon: Icon(Icons.payment),
              label: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Pay via Razorpay'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.saffron),
            ),
            SizedBox(height: 12),
            Text(
              'You will be redirected to a secure checkout. For testing, use Razorpay test keys (if configured).',
              style: TextStyle(color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }
}
