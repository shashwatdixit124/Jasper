package jasper.helper;

public class AsciiString {
	public static String getAsciiFromString(String data)
	{
		int len = data.length();
		String convData = "";
		char ch ;
		int temp;
		String str = "";
		for(int i = 0;i<len;i++)
		{
			ch = data.charAt(i);
			temp = (int)ch;
			str = Integer.toString(temp);
			if(str.length() == 2)
				str = "0" + str;
			else if(str.length() == 1)
				str = "00" + str;
			convData += str;
		}
		return convData;
	}
	
	public static String getStringFromAscii(String data)
	{
		long len = data.length();
		String actualData = "";
		char ch ;
		int temp;
		String str = "";
		for(int i = 0;i<len;i+=3)
		{
			str = data.substring(i, i+3);
			temp = Integer.parseInt(str);
			ch = (char)temp;
			actualData += ch;
		}
		return actualData;
	}
}
