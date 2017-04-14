package jasper.helper;
import javax.servlet.http.*;

public class JasperCookie {
	
	Cookie[] cookies;
	
	public JasperCookie(HttpServletRequest request){
		cookies = request.getCookies();
	}
	
	public boolean exists(String key)
	{
		Cookie cookie;
		if(cookies != null)
		{
			for (int i = 0; i < cookies.length; i++){
				cookie = cookies[i];
				if((cookie.getName( )).compareTo(key) == 0 ){
					return true;
				}
			}
		}
		return false;
	}
	
	public String getValue(String key)
	{
		Cookie cookie;
		if(cookies != null)
		{
			for (int i = 0; i < cookies.length; i++){
				cookie = cookies[i];
				if((cookie.getName( )).compareTo(key) == 0 ){
					return cookie.getValue();
				}
			}
		}
		return null;
	}
	
	public boolean isNull(){
		return cookies == null;
	}
	
	public static void addCookieToResponse(String key, String val, HttpServletResponse response){
		Cookie c = new Cookie(key,val);
		c.setMaxAge(60*60*24);
		response.addCookie(c);
	}
}
