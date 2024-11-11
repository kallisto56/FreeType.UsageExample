namespace FreeType;


using System;
using System.Diagnostics;


extension FT_Err
{
	public mixin Check ()
	{
		if (this != .FT_Err_Ok)
		{
			String fileName = Compiler.CallerFilePath;
			int lineNumber = Compiler.CallerLineNum;
			int column = 0;

			Debug.WriteLine("WARNING: {} at line {}:{} in {}", this, lineNumber, column, fileName);
			Debug.Break();
		}
	}

	public mixin Resolve ()
	{
		if (this != .FT_Err_Ok)
		{
			String fileName = Compiler.CallerFilePath;
			String memberName = Compiler.CallerMemberName;
			int lineNumber = Compiler.CallerLineNum;
			int column = 0;

			return new Error(null, fileName, memberName, lineNumber, column)..Append(this.ToString(.. scope String()));
		}

		this
	}
}