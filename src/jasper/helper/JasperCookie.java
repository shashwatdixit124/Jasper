package jasper.helper;
import javax.servlet.http.*;

public class JasperCookie {
	
	Cookie[] cookies;
	HttpServletRequest request; 
	HttpServletResponse response;
	
	public JasperCookie(HttpServletRequest req, HttpServletResponse res){
		request = req;
		response = res;
		cookies = req.getCookies();
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
	
	public void add(String key, String val){
		Cookie c = new Cookie(key,val);
		c.setMaxAge(60*60*24);
		response.addCookie(c);
	}
	
	public void remove(String key){
		Cookie c = new Cookie(key,"");
		c.setMaxAge(0);
		response.addCookie(c);
	}
}
