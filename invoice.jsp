
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
        String[] cond=new String[]{gen.gettable(request.getParameter("S1"))};
        java.util.Vector vk=sgen.getDataQuery(conn,"SALESHEADER",cond);
        java.util.Vector data=sgen.getDataQuery(conn,"SALESDETAILV",cond);
        java.util.Vector BALANCE=sgen.getDataQuery(conn,"BALANCEMEMBER",new String[]{gen.gettable(vk.get(2))});
        int bal=0;
        if(BALANCE.size()>0) bal=gen.getInt(BALANCE.get(0));
         connMgr.freeConnection("db2", conn);
          connMgr.release();
          
        %>
  <body>
    <header class="clearfix">
      <div id="logo">
        <img src="image/logo.png">
      </div>
      <h1>Invoice &nbsp;&nbsp;<%=gen.gettable(vk.get(0))%></h1>
      <div id="company" class="clearfix">
        <div>Beauty Salon</div>
        <div>Batam,<br /> Nagoya Hill</div>
        <div>(62)832032009</div>
      </div>
      <div id="project">
        <div>Invoice Date :&nbsp;&nbsp;&nbsp;<%=gen.gettable(vk.get(1))%></div>
        <div>Member ID /Name:&nbsp;&nbsp;&nbsp;<%=gen.gettable(vk.get(2))%>&nbsp;/&nbsp;<%=gen.gettable(vk.get(8))%></div>
        <%if(gen.gettable(vk.get(4)).trim().length()>0){%>
        <div>Disc Card :&nbsp;&nbsp;&nbsp;<%=gen.gettable(vk.get(4))%>(<%=gen.gettable(vk.get(11))%>)</div>
        <%}%>
        <%if(gen.gettable(vk.get(12)).trim().length()>0){%>
        <div>Package :&nbsp;&nbsp;&nbsp;<%=gen.gettable(vk.get(12))%>(<%=gen.gettable(vk.get(13))%>)</div>
        <%}%>
        <%if(bal>0){%>
        <div><b>Balance :&nbsp;&nbsp;&nbsp;<%=gen.getNumberFormat(bal+"",0)%></b></div>
        <%}
        int GT=gen.getInt(vk.get(5))+gen.getInt(vk.get(6));
        %>
        <div>Gross Sales Amount:&nbsp;&nbsp;&nbsp;<%=gen.getNumberFormat(GT,0)%></div>
        <div>Discount Amount :&nbsp;&nbsp;&nbsp;<%=gen.getNumberFormat(vk.get(6),0)%></div>
        <div><b>Total Net Sales Amount :&nbsp;&nbsp;&nbsp;<%=gen.getNumberFormat(vk.get(5),0)%></b></div>
      </div>
    </header>
    <main>
      <table>
        <thead>
          <tr>
            <th>NO</th>
            <th class="service">ID</th>
            <th class="desc">ITEM/CARD/TREATMENT</th>
            <th>PRICE</th>
            <th>QTY</th>
            <th>TOTAL</th>
          </tr>
        </thead>
        <tbody>
        <%
        int h=1;
        int to=0;
        for(int m=0;m<data.size();m+=5){
            to+=gen.getInt(data.get(m+4));
        %>
          <tr>
            <td><%=h+""%></td>
            <td class="service"><%=gen.gettable(data.get(m))%></td>
            <td class="desc"><%=gen.gettable(data.get(m+1))%></td>
            <td class="unit"><%=gen.getNumberFormat(data.get(m+2),0)%></td>
            <td class="qty"><%=gen.gettable(data.get(m+3))%></td>
            <td class="total"><%=gen.getNumberFormat(data.get(m+4),0)%></td>
          </tr>
      <!--    <tr>
            <td colspan="4">SUBTOTAL</td>
            <td class="total">$5,200.00</td>
          </tr>
          <tr>
            <td colspan="4">TAX 25%</td>
            <td class="total">$1,300.00</td>
          </tr>-->
       <% h++;
        }%>   
          <tr>
            <td colspan="5" class="grand total">TOTAL</td>
            <td class="grand total"><%=gen.getNumberFormat(to+"",0)%></td>
          </tr>
        </tbody>
      </table>
    </main>
    <footer>
      Invoice was created on a computer and is valid without the signature and seal.
    </footer>
  </body>
</html>
