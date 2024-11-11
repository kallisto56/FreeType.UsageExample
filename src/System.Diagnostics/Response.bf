namespace System;


using System;
using System.Diagnostics;


typealias Response = Result<void, Error>;
typealias Response<T> = Result<T, Error>;


extension Result<T, TErr> where TErr : Error
{
	public mixin Resolve ()
	{
		Result<T, TErr> response = this;

		if (this case .Err(Error e))
		{
			String fileName = Compiler.CallerFilePath;
			String memberName = Compiler.CallerMemberName;
			int lineNumber = Compiler.CallerLineNum;
			int column = 0;

			return new Error(e, fileName, memberName, lineNumber, column);
		}

		response
	}


	[Inline]
	public static implicit operator Result<T, TErr>(TErr error)
	{
	    return .Err(error);
	}
}