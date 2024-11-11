namespace System;


using System;
using System.Collections;


class Error
{
	static public List<Error> sCollection = new List<Error>() ~ DeleteContainerAndItems!(_);


	public Error mUnderlyingError;
	public String mMessage;

	public String mFilePath;
	public String mMethodName;
	public uint32 mLineNumber;
	public uint32 mColumn;


	public this (Error underlyingError = null, String filePath = Compiler.CallerFilePath, String methodName = Compiler.CallerMemberName, int lineNumber = Compiler.CallerLineNum, int column = 0)
	{
		this.mMessage = new String();

		this.mUnderlyingError = underlyingError;

		this.mFilePath = filePath;
		this.mMethodName = methodName;
		this.mLineNumber = uint32(lineNumber);
		this.mColumn = uint32(column);

		Self.sCollection.Add(this);
	}


	public ~this ()
	{
		delete this.mMessage;
		this.mMessage = null;
	}


	[Inline]
	public void Append (StringView message)
	{
		this.mMessage.Append(message);
	}


	[Inline]
	public void AppendF (StringView format, params Object[] args)
	{
		this.mMessage.AppendF(format, params args);
	}


	override public void ToString (String buffer)
	{
		if (this.mUnderlyingError != null)
		{
			this.mUnderlyingError.ToString(buffer);
			buffer.Append("\n");
		}

		// First error gets prepended with 'ERROR: '
		// Subsequent errors get prepended with '  > '
		if (this.mUnderlyingError == null)
			buffer.Append("ERROR: ");
		else
			buffer.Append("  > ");

		String message = this.mMessage.IsEmpty == false
			? this.mMessage
			: "...";

		buffer.AppendF(
			"{} at line {}:{} in {}",
			message,
			this.mLineNumber,
			this.mColumn,
			this.mFilePath
		);
	}
}