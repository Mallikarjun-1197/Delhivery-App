import sys
import os

# Add backend to path so we can simulate how Azure loads it
sys.path.append(os.path.join(os.getcwd(), 'backend'))

print("Attempting to import function_app...")

try:
    import backend.function_app as fa
    print("✅ Successfully imported function_app!")
    print(f"App object: {fa.app}")
except ImportError as e:
    print(f"❌ ImportError: {e}")
    sys.exit(1)
except Exception as e:
    print(f"❌ Crash during import: {e}")
    sys.exit(1)
