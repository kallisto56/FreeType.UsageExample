namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;


class FreeType
{
	public class Library
	{
		static public Library sMainThreadInstance;

		public FT_Library mHandle;


		public this (bool bIsMainThreadInstance = false)
		{
			if (bIsMainThreadInstance)
				Library.sMainThreadInstance = this;
		}


		public Response Initialize ()
		{
			FT_Init_FreeType(out this.mHandle).Resolve!();
			return .Ok;
		}


		public ~this ()
		{
			if (this.mHandle != null)
				FT_Done_FreeType(this.mHandle).Check!();
		}
	}
}
