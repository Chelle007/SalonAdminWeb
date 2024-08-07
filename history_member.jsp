
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <jsp:include page="title.jsp" flush ="true"/>
    <link rel="stylesheet" href="assets/css/style_invoice.css" media="all" />
  </head>
  <%
        com.ysoft.General Gen = new com.ysoft.General();
        com.ysoft.General gen = new com.ysoft.General();  
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
        java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =Gen.gettable(enu.nextElement());
          //  System.out.println(pr+"="+Gen.gettable(request.getParameter(pr)));
        }        

  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        String[] cond=new String[]{gen.gettable(request.getParameter("S2"))};
        
        java.util.Vector data=sgen.getDataQuery(conn,"TREATMENTHEADER",cond);
        java.util.Vector detail=sgen.getDataQuery(conn,"TREATMENTDETAIL2",cond);
        java.util.Vector balance=sgen.getDataQuery(conn,"BALANCEMEMBER",new String[]{gen.gettable(data.get(2))});
        int bal=0;
        if(balance.size()>0) bal=gen.getInt(balance.get(0));
         connMgr.freeConnection("db2", conn);
          connMgr.release();
          //SELECT [TREATMENT_RECORD_ID],[TREATMENT_DATE],a.[MEMBER_ID],[SALES_ID],a.[CARD_ID],[TOTAL_TREATMENT],[TOTAL_MATERIAL_COST],[REMARK],MEMBER_NAME,CARD_NAME,a.voucher_no,TOTAL
        %>
  <body>
    <header class="clearfix">
      <div id="logo">
        <img src="image/logo.png">
      </div>
      <h1>Slip Treatment</h1>
      <div id="company" class="clearfix">
        <div>Beauty Salon</div>
        <div>Batam,<br /> Nagoya Hill</div>
        <div>(62)832032009</div>
      </div>
      <div id="project">
        <div>Member ID /Name:&nbsp;&nbsp;&nbsp;<b><%=gen.gettable(request.getParameter("S1"))%>&nbsp;/&nbsp;<%=gen.gettable(data.get(8)).trim()%></b></div>
        <div>Card No:&nbsp;&nbsp;&nbsp;<b><%=gen.gettable(data.get(10)).trim()%></b></div>
        <div>Date :&nbsp;&nbsp;&nbsp;<b><%=gen.gettable(data.get(1)).trim()%></b></div>
        <div>Total Treatment :&nbsp;&nbsp;&nbsp;<b><%=gen.getNumberFormat(data.get(5),0)%></b></div>
        <div>Balance :&nbsp;&nbsp;&nbsp;<b><%=gen.getNumberFormat(bal+"",0)%></b></div>
      </div>
    </header>
    <main>
      <p><b>Treatment Info</b>
      <table>
        <thead>
          <tr>
              <th>TREATMENT</th>
              <th>PERSONAL IN CHARGE</th>
              <th>QTY</th>   
              <th>PRICE</th>     
              <th>TOTAL</th>    
              <th>DISC AMT</th>    
          </tr>
        </thead>
        <tbody>
        <%
//SELECT TREATMENT_RECORD_DETAIL_ID,A.TREATMENT_ID,TREATMENT_NAME,A.EMPLOYEE_ID,EMPLOYEE_NAME,A.quantity,A.PRICE,A.quantity*A.PRICE,A.DISC_PCT,A.quantity*A.PRICE*A.DISC_PCT/100 FROM TREATMENT_RECORD_DETAIL 
      for(int m=0;m<detail.size();m+=10){
        %>
          <tr>
            <td class="service"><%=gen.gettable(detail.get(m+2))%></td>
            <td class="desc"><%=gen.gettable(detail.get(m+4))%></td>
            <td class="unit"><%=gen.getNumberFormat(detail.get(m+5),0)%></td>
            <td class="unit"><%=gen.getNumberFormat(detail.get(m+6),0)%></td>
            <td class="unit"><%=gen.getNumberFormat(detail.get(m+7),0)%></td>
            <td class="unit"><%=gen.getNumberFormat(detail.get(m+9),0)%></td>
          </tr>
       <% 
        }%>   
        </tbody>
      </table>
    </main>
  </body>
</html>
