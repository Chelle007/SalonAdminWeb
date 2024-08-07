
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
        java.util.Vector data=sgen.getDataQuery(conn,"HISTORYTREATMENT",cond);
        java.util.Vector card=sgen.getDataQuery(conn,"INFOCARDMEMBER",cond);
        java.util.Vector free=sgen.getDataQuery(conn,"HISTORYFREETREATMENT",cond);
        java.util.Vector disc=sgen.getDataQuery(conn,"HISTORYUSINGVOUCHER",cond);
         connMgr.freeConnection("db2", conn);
          connMgr.release();
          
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
        <div>Member ID /Name:&nbsp;&nbsp;&nbsp;<%=gen.gettable(request.getParameter("S1"))%>&nbsp;/&nbsp;<%=gen.gettable(card.get(0))%></div>
      </div>
    </header>
    <main>
      <p><b>Available Card</b>
      <table>
        <thead>
          <tr>
             <th class="service">DATE</th>
            <th class="desc">REMARK</th>
            <th class="desc">VOUCHER NO</th>
            <th>CARD VALUE</th>
            <th>EXPIRED DATE</th>
          </tr>
        </thead>
        <tbody>
        <%
//sales.[SALES_ID],sales_date,SALES_DETAILS_CARD.[CARD_ID],card_name,SALES_DETAILS_CARD.[VOUCHER_NO],SALES_DETAILS_CARD.[CARD_VALUE],Expired_DATE 
      for(int m=0;m<card.size();m+=8){
        %>
          <tr>
            <td class="service"><%=gen.gettable(card.get(m+2))%></td>
            <td class="desc"><%=gen.gettable(card.get(m+4))%></td>
            <td class="desc"><%=gen.gettable(card.get(m+5))%></td>
            <td class="unit"><%=gen.getNumberFormat(card.get(m+6),0)%></td>
            <td class="desc"><%=gen.gettable(card.get(m+7))%></td>
          </tr>
       <% 
        }%>   
        </tbody>
      </table>
      <p><b>Balance Information</b>
      <table>
        <thead>
          <tr>
            <th>NO</th>
            <th class="service">DATE</th>
            <th class="desc">REMARK</th>
            <th>TOP UP VALUE</th>
            <th>TREATMENT VALUE</th>
             <th>BALANCE</th>
          </tr>
        </thead>
        <tbody>
        <%
        int h=1;
        int to=0;
//SELECT [DT],[REMARK],[INBALANCE],[OUTBALANCE]  FROM [VTRX_MEMBERHISTORY] WHERE [MEMBER_ID]=? ORDER BY DT,TP
      for(int m=0;m<data.size();m+=4){
            to+=gen.getInt(data.get(2+m))-gen.getInt(data.get(3+m));
        %>
          <tr>
            <td><%=h+""%></td>
            <td class="service"><%=gen.gettable(data.get(m))%></td>
            <td class="desc"><%=gen.gettable(data.get(m+1))%></td>
            <td class="unit"><%=gen.getNumberFormat(data.get(m+2),0)%></td>
            <td class="unit"><%=gen.getNumberFormat(data.get(m+3),0)%></td>
            <td class="total"><%if(m==data.size()-4){%><b><%=gen.getNumberFormat(to,0)%></b><%}else{%><%=gen.getNumberFormat(to,0)%><%}%></td>
          </tr>
       <% h++;
        }%>   
        </tbody>
      </table>
      <%if(free.size()>0){%>
      <p><b>Free Treatment Card</b>
      <table>
        <thead>
          <tr>
            <th class="service">TREATMENT DATE</th>
            <th class="desc">REMARK</th>
            <th  class="total">TREATMENT PRICE</th>
          </tr>
        </thead>
        <tbody>
        <%
        for(int m=0;m<free.size();m+=3){
        %>
          <tr>
            <td class="desc"><%=gen.gettable(free.get(m))%></td>
            <td class="desc"><%=gen.gettable(free.get(m+1))%></td>
            <td class="total"><b><%=gen.getNumberFormat(free.get(m+2),0)%></b></td>
          </tr>
       <% 
        }%>   
        </tbody>
      </table>
      <%}%>
      <%if(disc.size()>0){%>
      <p><b>Discount Card</b>
      <table>
        <thead>
          <tr>
            <th class="service">DATE</th>
            <th class="desc">REMARK</th>
            <th class="desc">CARD NAME</th>
            <th class="total">DISC AMOUNT</th>
            <th class="total">AMT BEF. DISC</th>
            <th class="total">AMOUNT (PAID)</th>
          </tr>
        </thead>
        <tbody>
        <%
        for(int m=0;m<disc.size();m+=7){
        %>
          <tr>
            <td class="desc" nowrap><%=gen.gettable(disc.get(m))%></td>
            <td class="desc"><%=gen.gettable(disc.get(m+2)).trim()%></td>
            <td class="desc"><%=gen.gettable(disc.get(m+3)).trim()%></td>
            <td class="total"><b><%=gen.getNumberFormat(disc.get(m+4),0)%></b></td>
            <td class="total"><%=gen.getNumberFormat(disc.get(m+5),0)%></td>
            <td class="total"><%=gen.getNumberFormat(disc.get(m+6),0)%></td>
          </tr>
       <% 
        }%>   
        </tbody>
      </table>
      <%}%>
    </main>
  </body>
</html>
