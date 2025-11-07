#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys

def main():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'pandittalk.settings')
    try:
        from django.core.management import execute_from_command_line
    except Exception as exc:
        # Re-raise with same stack trace; Django will give the proper error text.
        raise
    execute_from_command_line(sys.argv)

if __name__ == '__main__':
    main()
