namespace FreeType.UsageExample;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;


extension FreeType
{
	public class FontFace
	{
		public FT_Face mHandle;

		public String mFileName;
		public String mFamilyName;
		public String mStyleName;

		public float mPointSize;
		public float mLineHeight;
		public float mAscent;
		public float mDescent;


		public Response Initialize (StringView fileName, int faceIdx, float pointSize)
		{
			this.mFileName.Set(fileName);

			FT_New_Face(Library.sMainThreadInstance.mHandle, this.mFileName.CStr(), .(faceIdx), out this.mHandle).Resolve!();

			this.mFamilyName.Set(StringView(this.mHandle.family_name));
			this.mStyleName.Set(StringView(this.mHandle.style_name));

			this.SetSize(pointSize);

			return .Ok;
		}


		public void SetSize (float pointSize)
		{
			if (pointSize == this.mPointSize)
				return;
	
			this.mPointSize = pointSize;
	
			FT_Set_Char_Size(this.mHandle, 0, .(this.mPointSize * FT_FIXED_POINT_SCALE), 0, 72).Check!();
	
			this.mLineHeight = this.mHandle.size.metrics.height / FT_FIXED_POINT_SCALE;
			this.mAscent = this.mHandle.size.metrics.ascender / FT_FIXED_POINT_SCALE;
			this.mDescent = this.mHandle.size.metrics.descender / FT_FIXED_POINT_SCALE;
		}


		public this ()
		{
			this.mFileName = new String();
			this.mFamilyName = new String();
			this.mStyleName = new String();
		}


		public ~this ()
		{
			if (this.mHandle != null)
				FT_Done_Face(this.mHandle).Check!();

			delete this.mFileName;
			delete this.mFamilyName;
			delete this.mStyleName;
		}
	}
}