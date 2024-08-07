<%
	javax.servlet.http.HttpSession ses = request.getSession();   
	if (ses.getAttribute("User") == null){//checking expired session
%>
	   <jsp:include page="login.jsp"/>
<%
	}else{                    
        com.ysoft.General Gen = new com.ysoft.General();
        com.ysoft.General gen = new com.ysoft.General();  
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
        System.out.println(Gen.gettable(request.getParameter("tp"))+","+Gen.gettable(request.getParameter("id"))+",act="+Gen.gettable(request.getParameter("act")));
        
       //parameter oper=del (delete),oper=edit=update
        java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =Gen.gettable(enu.nextElement());
 //           System.out.println(pr+"="+Gen.gettable(request.getParameter(pr)));
        }        
        String tp=gen.gettable(request.getParameter("tp"));
      	java.sql.Connection conn = connMgr.getConnection("db2");        
        java.io.PrintWriter log = new java.io.PrintWriter(new java.io.FileWriter(gen.getDataLogFileQuery(), true), true);
      	com.ysoft.subgeneral queryclass = new com.ysoft.subgeneral();

        String[] judul = null;
        String prefix = "";
        // ubah sini
        if ("P_EMPLOYEE".equals(tp)) {
            judul = new String[]{"ID", "E_ID", "Name", "Manage_level", "Address", "Contact_no", "Join_date", "Resign_date", "Salary_percentage", "Salary_amount", "Salary_type"};
            prefix = "E";
        } else if ("P_MEMBER".equals(tp)) {
            judul = new String[]{"ID", "M_ID", "Name", "Category", "Address", "Contact_no"};
            prefix = "M";
        } else if ("P_SUPPLIER".equals(tp)) {
            judul = new String[]{"ID", "SU_ID", "Name", "Address", "Contact_no", "Payment_grace_period"};
            prefix = "SU";
        } else if ("P_AGENT".equals(tp)) {
            judul = new String[]{"ID", "A_ID", "Name", "Address", "Contact_no", "Agent_fee_percentage"};
            prefix = "A";
        } else if ("S_BANK".equals(tp)) {
            judul = new String[]{"ID", "BA_ID", "Bank_name", "Bank_account", "Bank_account_name"};
            prefix = "BA";
        } else if ("S_ITEM".equals(tp)) {
            judul = new String[]{"ID", "I_ID", "Item_desc", "Cat", "Qty", "Unit_type", "Report_unit", "Volume_per_unit", "Purchase", "Sales_1", "Sales_2", "Sales_3", "Sales_4", "Min_stock"};
            prefix = "I";
        }

        String msg="";
        if (gen.gettable(request.getParameter("act")).equalsIgnoreCase("save")) {
            if (gen.gettable(request.getParameter("oper")).equalsIgnoreCase("del")) {
                String ID = "";
                java.util.Vector d = (java.util.Vector) ses.getAttribute("data");
                for (int m = 0; m < d.size(); m += judul.length) {
                    if (gen.getInt(request.getParameter("id")) == (m / judul.length + 1)) {
                        ID = gen.gettable(d.get(m + 1)).trim();
                        break;
                    }
                }
                msg = sgen.update(conn, tp + "DELETE", new String[]{ID});
                msg = sgen.update(conn, "LOGMENUPARMADD", new String[]{gen.gettable(ses.getAttribute("User")), tp + "DELETE", ID});
            } else if (gen.gettable(request.getParameter("oper")).equalsIgnoreCase("edit")) {
                java.util.Vector d = (java.util.Vector) ses.getAttribute("data");
                String[] updateArray = new String[judul.length - 1];
                for (int i = 2; i < judul.length; i++) {
                    updateArray[i - 2] = gen.gettable(request.getParameter(judul[i]));
                }
                updateArray[judul.length - 2] = gen.gettable(request.getParameter(judul[1]));

                msg = sgen.update(conn, tp + "UPDATE", updateArray);
                msg = sgen.update(conn, "LOGMENUPARMADD", new String[]{gen.gettable(ses.getAttribute("User")), tp + "UPDATE", gen.gettable(request.getParameter(judul[1]))});
            } else {
            //System.out.println(new java.util.Date()+",in add");
                String ID = "";
                java.util.Vector membx = sgen.getDataQuery(conn, tp + "MAXID", new String[0]);
                if (membx.size() > 0) {
                    String p = gen.gettable(membx.get(0)).trim().substring(prefix.length());
                    int nextNumber = gen.getInt(p) + 1;
                    ID = prefix + String.format("%03d", nextNumber);
                } else {
                    ID = prefix + "001";
                }
                String[] addArray = new String[judul.length - 1];
                addArray[0] = ID;
                for (int i = 1; i < addArray.length; i++) {
                    addArray[i] = gen.gettable(request.getParameter(judul[i+1]));
                }
                msg = sgen.update(conn, tp + "ADD", addArray);
                msg = sgen.update(conn, "LOGMENUPARMADD", new String[]{gen.gettable(ses.getAttribute("User")), tp + "ADD", ID});
            }
        }
            System.out.println(new java.util.Date()+",keluar and query>>"+tp);
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>
	   <jsp:include page="master1k.jsp"/>
<%}%>
