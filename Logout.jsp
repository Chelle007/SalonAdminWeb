<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
	    javax.servlet.http.HttpSession ses = request.getSession();    
        com.ysoft.General Gen = new com.ysoft.General(); 
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
        if(ses.getAttribute("User")!=null){
    		System.out.println("["+new java.util.Date().toString()+"] Logout by User ID.="+ses.getAttribute("User"));
    		ses.invalidate();

        } 
    		response.sendRedirect("login.jsp");
%>
<HTML>
<HEAD>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
</HTML>