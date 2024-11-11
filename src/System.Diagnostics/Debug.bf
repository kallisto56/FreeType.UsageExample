namespace System.Diagnostics;


using System;


extension Debug
{
	static public void Report (Error e, bool bIsCritical = false)
	{
		Debug.WriteLine(e.ToString(.. scope String()));

		if (bIsCritical == true && Debug.IsDebuggerPresent == true)
			Debug.SafeBreak();
	}


	static public mixin Warning (StringView message)
	{
		String fileName = Compiler.CallerFilePath;
		int lineNumber = Compiler.CallerLineNum;
		int column = 0;

		Debug.WriteLine("WARNING: {} at line {}:{} in {}", message, lineNumber, column, fileName);
	}
}