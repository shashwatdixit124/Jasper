package jasper.helper;

import java.util.*;

public class JasperDb {
	ConnectionResult cr;
	JasperConnection conn;
	List<JasperStatement> listJs;
	boolean usePrev;
	JasperStatement stmt;
	
	public JasperDb(String db, String uname, String pass){
		conn = new JasperConnection(db, uname, pass);
		cr = conn.start();
		listJs = new ArrayList<JasperStatement>();
		usePrev = true;
		stmt = new JasperStatement(conn);
	}
	
	public QueryResult executeQuery(String query){
		if(usePrev)
		{
			usePrev = false;
			return stmt.executeQuery(query);
		}
		JasperStatement newStmt = new JasperStatement(conn);
		listJs.add(newStmt);
		return newStmt.executeQuery(query);
	}
	
	public int executeUpdate(String query){
		if(usePrev)
		{
			usePrev = false;
			return stmt.executeUpdate(query);
		}
		JasperStatement newStmt = new JasperStatement(conn);
		listJs.add(newStmt);
		return newStmt.executeUpdate(query);
	}
	
	public void usePrev()
	{
		usePrev = true;
	}
	
	public ConnectionResult getConnectionResult(){
		return cr;
	}
	
	public void close()
	{
		stmt.close();
		Iterator itr=listJs.iterator();
		while(itr.hasNext())
		{
			JasperStatement temp = (JasperStatement)itr.next();
			temp.close();
		}
		conn.close();
	}
}
