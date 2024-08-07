<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
<title>3R Corporate</title>
<link href="image/3R.png" rel="icon">
		<meta name="description" content="3 styles with inline editable feature" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="assets/css/bootstrap.min.css" />
		<link rel="stylesheet" href="assets/font-awesome/4.5.0/css/font-awesome.min.css" />

		<!-- page specific plugin styles -->
		<link rel="stylesheet" href="assets/css/jquery-ui.custom.min.css" />
		<link rel="stylesheet" href="assets/css/jquery.gritter.min.css" />
		<link rel="stylesheet" href="assets/css/select2.min.css" />
		<link rel="stylesheet" href="assets/css/bootstrap-datepicker3.min.css" />
		<link rel="stylesheet" href="assets/css/bootstrap-editable.min.css" />

		<!-- text fonts -->
		<link rel="stylesheet" href="assets/css/fonts.googleapis.com.css" />

		<!-- ace styles -->
		<link rel="stylesheet" href="assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />

		<!--[if lte IE 9]>
			<link rel="stylesheet" href="assets/css/ace-part2.min.css" class="ace-main-stylesheet" />
		<![endif]-->
		<link rel="stylesheet" href="assets/css/ace-skins.min.css" />
		<link rel="stylesheet" href="assets/css/ace-rtl.min.css" />

		<!--[if lte IE 9]>
		  <link rel="stylesheet" href="assets/css/ace-ie.min.css" />
		<![endif]-->

		<!-- inline styles related to this page -->

		<!-- ace settings handler -->
		<script src="assets/js/ace-extra.min.js"></script>

		<!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

		<!--[if lte IE 8]>
		<script src="assets/js/html5shiv.min.js"></script>
		<script src="assets/js/respond.min.js"></script>
		<![endif]-->
	</head>
<%
	javax.servlet.http.HttpSession ses = request.getSession();   
	if (ses.getAttribute("User") == null){//checking expired session
%>
	   <jsp:forward page="login.jsp"/>
<%
	}                    
        com.ysoft.General Gen = new com.ysoft.General();
        com.ysoft.General gen = new com.ysoft.General();  
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
        java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =Gen.gettable(enu.nextElement());
      //      System.out.println(pr+"="+Gen.gettable(request.getParameter(pr)));
        }        

  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        String msg="";
        String glid=Gen.gettable(request.getParameter("Y11"));
        String titl="General Ledger";
        boolean add=false;
        if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){            
            conn.setAutoCommit(false);        
           String crntyear="",crntmonth="",ty="",tm="";
            String trx=Gen.gettable(request.getParameter("P1"));
            java.util.Vector sd=gen.getElement('-',trx+"-");
            if(sd.size()>0){
                tm=gen.gettable(sd.get(1));
                ty=gen.gettable(sd.get(2));
            }
            java.util.Vector userdef=sgen.getDataQuery(conn,"USERDEF",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
           if(userdef.size()>0){
              crntmonth=gen.gettable(userdef.get(0));
              crntyear=gen.gettable(userdef.get(1));
              if(crntmonth.length()==1)crntmonth="0"+crntmonth;
           }
            String prevy=crntyear,prevm=(gen.getInt(crntmonth)-1)+"";
             
            if(prevm.equalsIgnoreCase("0")){
              prevy=(gen.getInt(prevy)-1)+"";
              prevm="12";
            }
            
           String SEQ="1";
            if(glid.length()==0){
                java.util.Vector gl=sgen.getDataQuery(conn,"GLMAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),ty.substring(2)+tm+"%"});
                if(gl.size()>0){
                    String x=gen.gettable(gl.get(0)).trim().substring(4);
                    SEQ=(gen.getInt(x)+1)+"";
                }
                String xGLID=SEQ+"";
                glid=SEQ+"";
                for(int m=xGLID.length();m<5;m++){
                    glid="0"+glid;
                }
                glid=ty.substring(2)+tm+glid;
                add=true;
            }
            java.util.Vector dta=(java.util.Vector)ses.getAttribute("OLDGL");//lepasin
            int startm=gen.getInt(tm);
            int endm=gen.getInt(prevm);
            if(startm>endm){
                endm+=12;
            }
            for(int sm=0;sm<dta.size();sm+=7){
                String acct=gen.gettable(dta.get(sm));
                String d=gen.gettable(dta.get(sm+3));
                String c=gen.gettable(dta.get(sm+4));
                //System.out.println(startm+","+endm);
                String loopy=ty;
                for(int smm=startm;smm<=endm;smm++){
                    System.out.println(smm+","+ty);
                  int loopm=smm;
                  if(smm>12){
                    loopy=""+(gen.getInt(loopy)+1);
                    loopm=1;
                  }
                  java.util.Vector bal=sgen.getDataQuery(conn,"ACCOUNTMONTHLY",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),loopy,loopm+"",acct});
                  double amt=(gen.getformatdouble(d)-gen.getformatdouble(c));
                  if(bal.size()>0){
                  //System.out.println("before=debit="+d+",credit="+c);
                      amt=gen.getformatdouble(bal.get(0))-amt;       
                    //  System.out.println(amt);               
                      if(msg.length()==0) msg=sgen.update(conn,"ACCTBALUPDATE",new String[]{amt+"",gen.gettable(ses.getAttribute("TxtErcode")),acct,loopy,loopm+""});
                  }                
                }
            }
            if(msg.length()==0) msg=sgen.update(conn,"GLDETAILDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),glid});
            
            int hx=gen.getInt(request.getParameter("CS"));
            String cc="IDR";
            for(int m=1;m<=hx;m++){
                //SEQ,[Acct],Mst_Account.DESCRIPTION,[Credit],NOTEITEM1,trxtype,remark
                String acct=gen.gettable(request.getParameter("A"+m));
                String desc=gen.gettable(request.getParameter("B"+m));
                String rate=gen.gettable(request.getParameter("C"+m));
                String d=gen.gettable(request.getParameter("D"+m));
                String c=gen.gettable(request.getParameter("E"+m));
                String idrd=gen.gettable(request.getParameter("D"+m));
                String idrc=gen.gettable(request.getParameter("E"+m));
                String job=gen.gettable(request.getParameter("F"+m));
                String rem=gen.gettable(request.getParameter("G"+m));
                if(desc.trim().indexOf("SGD")>0){
                    cc="SGD";                            
                }else if(desc.trim().indexOf("USD")>0){
                    cc="USD";
                }
                for(int smm=startm;smm<=endm;smm++){
                  String loopy=ty;
                  int loopm=smm;
                  if(smm>12){
                    loopy=""+(gen.getInt(loopy)+1);
                    loopm=1;
                  }
                  java.util.Vector bal=sgen.getDataQuery(conn,"ACCOUNTMONTHLY",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),loopy,loopm+"",acct});
                  double amt=(gen.getReleaseNumberFormat(d)-gen.getReleaseNumberFormat(c));
                  if(bal.size()>0){
                      amt=gen.getformatdouble(bal.get(0))+amt;
                      //System.out.println("debit="+d+",credit="+c+","+amt+",bal="+bal.get(0));                      
                      if(msg.length()==0) msg=sgen.update(conn,"ACCTBALUPDATE",new String[]{amt+"",gen.gettable(ses.getAttribute("TxtErcode")),acct,loopy,loopm+""});
                  }else{
                      if(msg.length()==0) msg=sgen.update(conn,"ACCTBALADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),acct,loopy,loopm+"",amt+""});                  
                  }                
                }
                
                //[ErCode] ,[GLId],[TrxDate],curr,[Remarks],Trxtype,Refno
                
                //[ErCode] ,[GLId],[AcctNo],Debet,Credit,Rate,IDrDebet,IDrCredit,jobno,[note1],note2
                if(cc.trim().equalsIgnoreCase("IDR")){
                    d="0";
                    c="0";
                }else{
                    idrd=""+(gen.getReleaseNumberFormat(d)*gen.getReleaseNumberFormat(rate));
                    idrc=""+(gen.getReleaseNumberFormat(c)*gen.getReleaseNumberFormat(rate));
                }
//[ErCode] ,[GLId],[AcctNo],Debet,Credit,Rate,IDrDebet,IDrCredit,jobno,[note1],note2                                
                String[] xc=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),glid,acct,d,c,rate,idrd,idrc,job,rem,""};
                if(msg.length()==0) msg=sgen.update(conn,"GLDETAILADD",xc);                
            }
            if(add){
                if(msg.length()==0) msg=sgen.update(conn,"GLADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),glid,gen.gettable(request.getParameter("P1")),cc,gen.gettable(request.getParameter("P2")),"",""});
            }else{
                if(msg.length()==0) msg=sgen.update(conn,"GLUPDATE",new String[]{gen.gettable(request.getParameter("P2")),gen.gettable(ses.getAttribute("TxtErcode")),glid});
            }
            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"GL",glid+"|"});
            if(msg.length()>0){
                conn.rollback();
                msg="(Save Failed!!"+msg+")";
            }else{
                conn.commit();
                add=false;
                msg="(Saved Successfully)";
            }     
            conn.setAutoCommit(true);
        }
        if(glid.length()==0){
            add=true;
        }else{
            add=false;
        }
        String[] cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),glid};
        java.util.Vector vk=sgen.getDataQuery(conn,"GLBYID",cond);
        if(vk.size()==0){
            vk.addElement("");
            vk.addElement("");
            vk.addElement("");
            vk.addElement("");
            vk.addElement("");
            vk.addElement("");            
        }
        String curr=gen.gettable(vk.get(2)).trim();
        double td=0,tc=0;
        java.util.Vector vkdtl=sgen.getDataQuery(conn,"GLDETAILBYID",cond);
        ses.setAttribute("OLDGL",vkdtl);
        if(request.getParameter("act")!=null){            
            int hx=gen.getInt(request.getParameter("CS"));
            java.util.Vector tmp=new java.util.Vector();
            for(int m=1;m<=hx;m++){
                if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DEL") && gen.getInt(request.getParameter("baris"))==m){
                }else{
                  tmp.addElement(request.getParameter("A"+m));
                  tmp.addElement(request.getParameter("B"+m));
                  tmp.addElement(request.getParameter("C"+m));
                  tmp.addElement(request.getParameter("D"+m));
                  tmp.addElement(request.getParameter("E"+m));
                  tmp.addElement(request.getParameter("F"+m));
                  tmp.addElement(request.getParameter("G"+m));
               }
            }
            vkdtl=tmp;
            if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("Add")){
              for(int m=0;m<7;m++){
                  if(m==2) vkdtl.addElement("1");
                  else if(m==3||m==4) vkdtl.addElement("0");
                  else  vkdtl.addElement("");
              }
            }
        }
        if(vkdtl.size()==0){
            for(int m=0;m<7;m++){
                if(m==2) vkdtl.addElement("1");
                else if(m==3||m==4) vkdtl.addElement("0");
                else  vkdtl.addElement("");
            }
        }
        
        for(int m=0;m<vkdtl.size();m+=7){
            td+=gen.getformatdouble(vkdtl.get(m+3));
            tc+=gen.getformatdouble(vkdtl.get(m+4));
        }
        //System.out.println("tc="+tc);
         connMgr.freeConnection("db2", conn);
          connMgr.release();
          
        String view=Gen.gettable(request.getParameter("view"));
%>

	<body class="no-skin" onload="counttot()">
        <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
			         <form class="form-horizontal" name="BGA" method="POST" action="GLDetail.jsp?tp=<%=Gen.gettable(request.getParameter("tp"))%>" >
					<div class="page-content">
						<div class="page-header">
							<h1>
								<%=titl%> <%=msg%>
							</h1>
						</div><!-- /.page-header -->
						<div class="row">
                            <div id="user-profile-3" >
                              <table id="simple-table" class="table  table-bordered table-hover">
  								<thead>
  									<tr><td colspan=4><b>General Ledger</b><td></tr>
  								</thead>                
  								<tbody>
                                      <tr>
                                          <td>GL ID#:</td><td>
                                                <input type="hidden" id="Y11" name="Y11"  value="<%=glid%>"/><b><%=glid%></b>
                                          </td>
                                          <td>*Date:</td><td nowrap>
                                            <input type="hidden" name="S1" value="<%=gen.gettable(request.getParameter("S1"))%>" />
                                            <input type="hidden" name="S2" value="<%=gen.gettable(request.getParameter("S2"))%>" />                                            
                                            <%if(add){%>
                                                <input name="P1" class="input-medium date-picker"  id="P1" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("P1"))%>" placeholder="dd-mm-yyyy" /><i class="ace-icon fa fa-calendar"></i>
                                            <%}else{%>
                                                <input type="hidden" id="P1" name="P1"  value="<%=gen.gettable(vk.get(1))%>"/><b><%=gen.gettable(vk.get(1))%></b>
                                            <%}%>
                                            </td>
                                      </tr>
                                      <tr>
                                          <td>Total Debit:</td><td><input type="text" id="P3" maxlength="20" size="16" name="P3"  value="<%=gen.getNumberFormat(td,2)%>" />
                                          <td>Total Credit:</td><td><input type="text" id="P4" maxlength="20" size="16" name="P4"  value="<%=gen.getNumberFormat(tc,2)%>" />
                                      </tr>
                                      <tr>
                                          <td>Memo:</td><td colspan=3><input type="hidden" name="CS" value="<%=(vkdtl.size()/7)%>"><textarea name="P2" rows=2 cols=50 ><%=gen.gettable(vk.get(3)).trim()%></textarea> </td>
                                      </tr>
  								</tbody>
  							</table>
                         </div>
                        </div>
                        <div class="row">
                            <table id="Acct" class="table  table-bordered table-hover">
                				<thead>
                                        <th>ACCOUNT</th>
                                        <%if(!curr.equalsIgnoreCase("IDR")){%>
                                        <th>RATE</th>
                                        <%}%>
                                        <th>DEBIT</th>
                                        <th>CREDIT</th>                                                                        
                                        <th>JOBNO</th>                                                                        
                                        <th>REMARKS</th>
                                        <th>DEL</th>
                    				</thead>                
                    				<tbody>
                                    <%
                                    int hit=1;
                                    for(int i=0;i<vkdtl.size();i+=7){%>
                						<tr>
                							<td nowrap>
                          		              <input type="text" name="A<%=hit%>" size="5" value="<%=Gen.gettable(vkdtl.get(i)).trim()%>" disabled>
                          		              <input type="text" name="B<%=hit%>" size="25"  value="<%=Gen.gettable(vkdtl.get(i+1)).trim()%>" disabled>
                                              <%if(view.length()==0){%>
                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('ACCOUNT','A<%=hit%>','B<%=hit%>','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                              <%}%>
                                            </td>
                                            <%if(!curr.equalsIgnoreCase("IDR")){%>
                                            <td nowrap>
                                                <input type="text"   style="text-align:right;" id="C<%=hit%>" name="C<%=hit%>" maxlength="15" size="15" value="<%=Gen.getNumberFormat(vkdtl.get(i+2))%>" <%=view%>/>                                                
                                            </td>
                                            <%}%>
                							<td nowrap>
                                                <input type="text"   style="text-align:right;" id="D<%=hit%>" name="D<%=hit%>" maxlength="15" size="15" value="<%=Gen.getNumberFormat(vkdtl.get(i+3))%>" onchange="counttot()" <%=view%>/>
                                            </td>
                							<td nowrap>
                                                <input type="text"   style="text-align:right;" id="E<%=hit%>" name="E<%=hit%>" maxlength="15" size="15" value="<%=Gen.getNumberFormat(vkdtl.get(i+4))%>" onchange="counttot()" <%=view%>/>
                                            </td>
                							<td>
                                                <input type="text"    id="F<%=hit%>" name="F<%=hit%>" maxlength="20" size="15" value="<%=Gen.gettable(vkdtl.get(i+5)).trim()%>" <%=view%>/>
                                            </td>
                							<td>
                                                <input type="text"   id="F<%=hit%>" name="G<%=hit%>" maxlength="20" size="15" value="<%=Gen.gettable(vkdtl.get(i+6)).trim()%>" <%=view%>/>
                                            </td>
                                            <td nowrap><button class="btn btn-xs btn-danger"  onclick="ondel('<%=hit%>')">
  												<i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                            </td>
                   						</tr>
                                    <%hit++;
                                    }%>
                                        <tr><td colspan=5></td><td><a href="javascript:subm('Add')"><img width=20 height=20 src=image/plus.gif></a></td></tr>                                    
                				</tbody>
                			</table>
                        </div>
                      <%if(view.length()==0){%>
                        <div class="row" align=center>
                      		<button class="btn btn-info" type="button" onclick="setsave('1');">
                      			<i class="ace-icon fa fa-check bigger-110"></i>
                      			Save
                      		</button>
                      		<button class="btn btn-info" type="button" onclick="onreturn();">
                      			<i class="ace-icon fa fa-return bigger-110"></i>
                      			Back
                      		</button>
                            <%if(!add){%>
                      		<button class="btn btn-info" type="button" onclick="onadd();">
                      			<i class="ace-icon fa fa-plus bigger-110"></i>
                      			Add New
                      		</button>
                            <%}%>
                        </div>
                        <%}%>
					</div><!-- /.page-content -->
                    <input type="hidden" name="act" value="">
                    <input type="hidden" name="baris" value="">
                    <input type="hidden" name="add" value="<%=add%>">
                    
                    <input type="hidden" name="x" value="1">

                </form>                    
				</div>
			</div><!-- /.main-content -->

        <jsp:include page="footer.jsp" flush ="true"/>

		<!-- basic scripts -->

		<!--[if !IE]> -->
		<script src="assets/js/jquery-2.1.4.min.js"></script>

		<!-- <![endif]-->

		<!--[if IE]>
<script src="assets/js/jquery-1.11.3.min.js"></script>
<![endif]-->
		<script type="text/javascript">
			if('ontouchstart' in document.documentElement) document.write("<script src='assets/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>
		<script src="assets/js/bootstrap.min.js"></script>

		<!-- page specific plugin scripts -->

		<!--[if lte IE 8]>
		  <script src="assets/js/excanvas.min.js"></script>
		<![endif]-->
		<script src="assets/js/jquery-ui.custom.min.js"></script>
		<script src="assets/js/jquery.ui.touch-punch.min.js"></script>
		<script src="assets/js/jquery.gritter.min.js"></script>
		<script src="assets/js/bootbox.js"></script>
		<script src="assets/js/jquery.easypiechart.min.js"></script>
		<script src="assets/js/bootstrap-datepicker.min.js"></script>
		<script src="assets/js/jquery.hotkeys.index.min.js"></script>
		<script src="assets/js/bootstrap-wysiwyg.min.js"></script>
		<script src="assets/js/select2.min.js"></script>
		<script src="assets/js/spinbox.min.js"></script>
		<script src="assets/js/bootstrap-editable.min.js"></script>
		<script src="assets/js/ace-editable.min.js"></script>
		<script src="assets/js/jquery.maskedinput.min.js"></script>

		<!-- ace scripts -->
		<script src="assets/js/ace-elements.min.js"></script>
		<script src="assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">

            function onreturn(){
                location.href="GL.jsp?tp=GL&S1=<%=gen.gettable(request.getParameter("S1"))%>&S2=<%=gen.gettable(request.getParameter("S2"))%>";
            }
            function onadd(parm){
                location.href="GLDetail.jsp?add=true&tp=<%=request.getParameter("tp")%>&S1=<%=gen.gettable(request.getParameter("S1"))%>&S2=<%=gen.gettable(request.getParameter("S2"))%>";
            }
            
        	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
        		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
        		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
        	}
            function  setsave(Parm){
                  if(document.BGA.P1.value==""){
                      alert("Transaction Date must be filled!");
                  }else{
                     <%
                     int hc=1;
                     for(int i=0;i<vkdtl.size();i+=7){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.A<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     document.BGA.act.value="Save";
                      BGA.submit();
                  }
            }
            
            function counttot(){
                     var t1=0,t2=0;
                     <%
                     int htc=1;
                     for(int i=0;i<vkdtl.size();i+=7){%>
                        t1+=Digit(document.BGA.D<%=htc%>.value);
                        t2+=Digit(document.BGA.E<%=htc%>.value);
                     <%htc++;
                     }%>
                     
                     document.BGA.P3.value=NumberFormat(t1);
                     document.BGA.P4.value=NumberFormat(t2);
            }
            function  ondel(Parm1){                
                     <%
                     hc=1;
                     for(int i=0;i<vkdtl.size();i+=7){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.A<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     document.BGA.baris.value=Parm1;
                     document.BGA.act.value="DEL";
                      BGA.submit();
            }
              function Digit(num){
                 yes="";
                 for(i=0;i<num.length;i++)
                 {
                    if(num.charAt(i)!=","){
                       yes=yes+num.charAt(i);
                    }
                 }
                 return parseFloat(yes);
              }
              function NumberFormat(num){
              	str=num.toString();
                if(num<0){
                    str=str.substring(1,str.length);
                }
                if(str=='') return "0";
              	tts = str.indexOf(",");
              	if (tts!=-1) return str;
              	ttk = str.indexOf(".");
              	if(ttk==-1)ttk=str.length;
              	for(i=ttk-3;i>0;i-=4){
              		str=str.substring(0,i)+","+str.substring(i,str.length);
              		i++;
              	}
                if(num<0){
                    str="-"+str;
                }
              	return str;
              }
function RoundFloat(num,digit){
	str=num.toString();
	ttk = str.indexOf(".");
	var temp="";
	if(ttk!=-1){
		if(str.length-1-ttk>digit){
			temp=str.substring(0,ttk+1);
			des = parseInt(str.substring(ttk+1,ttk+1+digit));
			if(parseInt(str.charAt(ttk+digit+1))>4)des++;
			if(des<10)
			 temp += "0"+des.toString();
			else
			 temp += des.toString(); 
		}
		else{
			temp = str;
			for(i=str.length-1;i<ttk+digit;i++)temp+="0";
		}
	}
	else{		
		temp=str;
		if(digit>0)temp+=".";
		for(i=0;i<digit;i++)temp+="0";
	}
	return temp;
}
            
            function  subm(Parm){                
                     <%
                     hc=1;
                     for(int i=0;i<vkdtl.size();i+=7){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.A<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     document.BGA.act.value=Parm;
                      BGA.submit();
            }
			jQuery(function($) {
			
				var active_class = 'active';
				//editables on first profile page
				$.fn.editable.defaults.mode = 'inline';
				$.fn.editableform.loading = "<div class='editableform-loading'><i class='ace-icon fa fa-spinner fa-spin fa-2x light-blue'></i></div>";
			    $.fn.editableform.buttons = '<button type="submit" class="btn btn-info editable-submit"><i class="ace-icon fa fa-check"></i></button>'+
			                                '<button type="button" class="btn editable-cancel"><i class="ace-icon fa fa-times"></i></button>';    
				
				//editables 
				
				//text editable
			    $('#username')
				.editable({
					type: 'text',
					name: 'username'		
			    });
			
				$('#simple-table > thead > tr > th input[type=checkbox]').eq(0).on('click', function(){
					var th_checked = this.checked;//checkbox inside "TH" table header
					
					$(this).closest('table').find('tbody > tr').each(function(){
						var row = this;
						if(th_checked) $(row).addClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', true);
						else $(row).removeClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', false);
					});
				});
				
				//select/deselect a row when the checkbox is checked/unchecked
				$('#simple-table').on('click', 'td input[type=checkbox]' , function(){
					var $row = $(this).closest('tr');
					if($row.is('.detail-row ')) return;
					if(this.checked) $row.addClass(active_class);
					else $row.removeClass(active_class);
				});
				$('#user-profile-3')
				.find('input[type=file]').ace_file_input({
					style:'well',
					btn_choose:'Change avatar',
					btn_change:null,
					no_icon:'ace-icon fa fa-picture-o',
					thumbnail:'large',
					droppable:true,
					
					allowExt: ['jpg', 'jpeg', 'png', 'gif'],
					allowMime: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
				})
				.end().find('button[type=reset]').on(ace.click_event, function(){
					$('#user-profile-3 input[type=file]').ace_file_input('reset_input');
				})
				.end().find('.date-picker').datepicker().next().on(ace.click_event, function(){
					$(this).prev().focus();
				});
			
			
				$('#user-profile-3').find('input[type=file]').ace_file_input('show_file_list', [{type: 'image', name: $('#avatar').attr('src')}]);
			
			
				//add tooltip for small view action buttons in dropdown menu
				$('[data-rel="tooltip"]').tooltip({placement: tooltip_placement});
				
				//tooltip placement on right or left
				function tooltip_placement(context, source) {
					var $source = $(source);
					var $parent = $source.closest('table')
					var off1 = $parent.offset();
					var w1 = $parent.width();
			
					var off2 = $source.offset();
					//var w2 = $source.width();
			
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) return 'right';
					return 'left';
				}
				
				
				
				
				/***************/
				$('.show-details-btn').on('click', function(e) {
					e.preventDefault();
					$(this).closest('tr').next().toggleClass('open');
					$(this).find(ace.vars['.icon']).toggleClass('fa-angle-double-down').toggleClass('fa-angle-double-up');
				});
				
				//select2 editable
				var countries = [];
			    $.each({ "CA": "Canada", "IN": "India", "NL": "Netherlands", "TR": "Turkey", "US": "United States"}, function(k, v) {
			        countries.push({id: k, text: v});
			    });
			
				var cities = [];
				cities["CA"] = [];
				$.each(["Toronto", "Ottawa", "Calgary", "Vancouver"] , function(k, v){
					cities["CA"].push({id: v, text: v});
				});
				cities["IN"] = [];
				$.each(["Delhi", "Mumbai", "Bangalore"] , function(k, v){
					cities["IN"].push({id: v, text: v});
				});
				cities["NL"] = [];
				$.each(["Amsterdam", "Rotterdam", "The Hague"] , function(k, v){
					cities["NL"].push({id: v, text: v});
				});
				cities["TR"] = [];
				$.each(["Ankara", "Istanbul", "Izmir"] , function(k, v){
					cities["TR"].push({id: v, text: v});
				});
				cities["US"] = [];
				$.each(["New York", "Miami", "Los Angeles", "Chicago", "Wysconsin"] , function(k, v){
					cities["US"].push({id: v, text: v});
				});
				
				var currentValue = "NL";
                $('#example').DataTable();
			    $('#country').editable({
					type: 'select2',
					value : 'NL',
					//onblur:'ignore',
			        source: countries,
					select2: {
						'width': 140
					},		
					success: function(response, newValue) {
						if(currentValue == newValue) return;
						currentValue = newValue;
						
						var new_source = (!newValue || newValue == "") ? [] : cities[newValue];
						
						//the destroy method is causing errors in x-editable v1.4.6+
						//it worked fine in v1.4.5
						/**			
						$('#city').editable('destroy').editable({
							type: 'select2',
							source: new_source
						}).editable('setValue', null);
						*/
						
						//so we remove it altogether and create a new element
						var city = $('#city').removeAttr('id').get(0);
						$(city).clone().attr('id', 'city').text('Select City').editable({
							type: 'select2',
							value : null,
							//onblur:'ignore',
							source: new_source,
							select2: {
								'width': 140
							}
						}).insertAfter(city);//insert it after previous instance
						$(city).remove();//remove previous instance
						
					}
			    });
			
				$('#city').editable({
					type: 'select2',
					value : 'Amsterdam',
					//onblur:'ignore',
			        source: cities[currentValue],
					select2: {
						'width': 140
					}
			    });
			
			
				
				//custom date editable
				$('#signup').editable({
					type: 'adate',
					date: {
						//datepicker plugin options
						    format: 'yyyy/mm/dd',
						viewformat: 'yyyy/mm/dd',
						 weekStart: 1
						 
						//,nativeUI: true//if true and browser support input[type=date], native browser control will be used
						//,format: 'yyyy-mm-dd',
						//viewformat: 'yyyy-mm-dd'
					}
				})
			
			    $('#age').editable({
			        type: 'spinner',
					name : 'age',
					spinner : {
						min : 16,
						max : 99,
						step: 1,
						on_sides: true
						//,nativeUI: true//if true and browser support input[type=number], native browser control will be used
					}
				});
				
			
			    $('#login').editable({
			        type: 'slider',
					name : 'login',
					
					slider : {
						 min : 1,
						  max: 50,
						width: 100
						//,nativeUI: true//if true and browser support input[type=range], native browser control will be used
					},
					success: function(response, newValue) {
						if(parseInt(newValue) == 1)
							$(this).html(newValue + " hour ago");
						else $(this).html(newValue + " hours ago");
					}
				});
			
				$('#about').editable({
					mode: 'inline',
			        type: 'wysiwyg',
					name : 'about',
			
					wysiwyg : {
						//css : {'max-width':'300px'}
					},
					success: function(response, newValue) {
					}
				});
				
				
				
				// *** editable avatar *** //
				try {//ie8 throws some harmless exceptions, so let's catch'em
			
					//first let's add a fake appendChild method for Image element for browsers that have a problem with this
					//because editable plugin calls appendChild, and it causes errors on IE at unpredicted points
					try {
						document.createElement('IMG').appendChild(document.createElement('B'));
					} catch(e) {
						Image.prototype.appendChild = function(el){}
					}
			
					var last_gritter
					$('#avatar').editable({
						type: 'image',
						name: 'avatar',
						value: null,
						//onblur: 'ignore',  //don't reset or hide editable onblur?!
						image: {
							//specify ace file input plugin's options here
							btn_choose: 'Change Avatar',
							droppable: true,
							maxSize: 110000,//~100Kb
			
							//and a few extra ones here
							name: 'avatar',//put the field name here as well, will be used inside the custom plugin
							on_error : function(error_type) {//on_error function will be called when the selected file has a problem
								if(last_gritter) $.gritter.remove(last_gritter);
								if(error_type == 1) {//file format error
									last_gritter = $.gritter.add({
										title: 'File is not an image!',
										text: 'Please choose a jpg|gif|png image!',
										class_name: 'gritter-error gritter-center'
									});
								} else if(error_type == 2) {//file size rror
									last_gritter = $.gritter.add({
										title: 'File too big!',
										text: 'Image size should not exceed 100Kb!',
										class_name: 'gritter-error gritter-center'
									});
								}
								else {//other error
								}
							},
							on_success : function() {
								$.gritter.removeAll();
							}
						},
					    url: function(params) {
							// ***UPDATE AVATAR HERE*** //
							//for a working upload example you can replace the contents of this function with 
							//examples/profile-avatar-update.js
			
							var deferred = new $.Deferred
			
							var value = $('#avatar').next().find('input[type=hidden]:eq(0)').val();
							if(!value || value.length == 0) {
								deferred.resolve();
								return deferred.promise();
							}
			
			
							//dummy upload
							setTimeout(function(){
								if("FileReader" in window) {
									//for browsers that have a thumbnail of selected image
									var thumb = $('#avatar').next().find('img').data('thumb');
									if(thumb) $('#avatar').get(0).src = thumb;
								}
								
								deferred.resolve({'status':'OK'});
			
								if(last_gritter) $.gritter.remove(last_gritter);
								last_gritter = $.gritter.add({
									title: 'Avatar Updated!',
									text: 'Uploading to server can be easily implemented. A working example is included with the template.',
									class_name: 'gritter-info gritter-center'
								});
								
							 } , parseInt(Math.random() * 800 + 800))
			
							return deferred.promise();
							
							// ***END OF UPDATE AVATAR HERE*** //
						},
						
						success: function(response, newValue) {
						}
					})
				}catch(e) {}
				
				/**
				//let's display edit mode by default?
				var blank_image = true;//somehow you determine if image is initially blank or not, or you just want to display file input at first
				if(blank_image) {
					$('#avatar').editable('show').on('hidden', function(e, reason) {
						if(reason == 'onblur') {
							$('#avatar').editable('show');
							return;
						}
						$('#avatar').off('hidden');
					})
				}
				*/
			
				//another option is using modals
				$('#avatar2').on('click', function(){
					var modal = 
					'<div class="modal fade">\
					  <div class="modal-dialog">\
					   <div class="modal-content">\
						<div class="modal-header">\
							<button type="button" class="close" data-dismiss="modal">&times;</button>\
							<h4 class="blue">Change Avatar</h4>\
						</div>\
						\
						<form class="no-margin">\
						 <div class="modal-body">\
							<div class="space-4"></div>\
							<div style="width:75%;margin-left:12%;"><input type="file" name="file-input" /></div>\
						 </div>\
						\
						 <div class="modal-footer center">\
							<button type="submit" class="btn btn-sm btn-success"><i class="ace-icon fa fa-check"></i> Submit</button>\
							<button type="button" class="btn btn-sm" data-dismiss="modal"><i class="ace-icon fa fa-times"></i> Cancel</button>\
						 </div>\
						</form>\
					  </div>\
					 </div>\
					</div>';
					
					
					var modal = $(modal);
					modal.modal("show").on("hidden", function(){
						modal.remove();
					});
			
					var working = false;
			
					var form = modal.find('form:eq(0)');
					var file = form.find('input[type=file]').eq(0);
					file.ace_file_input({
						style:'well',
						btn_choose:'Click to choose new avatar',
						btn_change:null,
						no_icon:'ace-icon fa fa-picture-o',
						thumbnail:'small',
						before_remove: function() {
							//don't remove/reset files while being uploaded
							return !working;
						},
						allowExt: ['jpg', 'jpeg', 'png', 'gif'],
						allowMime: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
					});
			
					form.on('submit', function(){
						if(!file.data('ace_input_files')) return false;
						
						file.ace_file_input('disable');
						form.find('button').attr('disabled', 'disabled');
						form.find('.modal-body').append("<div class='center'><i class='ace-icon fa fa-spinner fa-spin bigger-150 orange'></i></div>");
						
						var deferred = new $.Deferred;
						working = true;
						deferred.done(function() {
							form.find('button').removeAttr('disabled');
							form.find('input[type=file]').ace_file_input('enable');
							form.find('.modal-body > :last-child').remove();
							
							modal.modal("hide");
			
							var thumb = file.next().find('img').data('thumb');
							if(thumb) $('#avatar2').get(0).src = thumb;
			
							working = false;
						});
						
						
						setTimeout(function(){
							deferred.resolve();
						} , parseInt(Math.random() * 800 + 800));
			
						return false;
					});
							
				});
			
				
			
				//////////////////////////////
				$('#profile-feed-1').ace_scroll({
					height: '250px',
					mouseWheelLock: true,
					alwaysVisible : true
				});
			
				$('a[ data-original-title]').tooltip();
			
				$('.easy-pie-chart.percentage').each(function(){
				var barColor = $(this).data('color') || '#555';
				var trackColor = '#E2E2E2';
				var size = parseInt($(this).data('size')) || 72;
				$(this).easyPieChart({
					barColor: barColor,
					trackColor: trackColor,
					scaleColor: false,
					lineCap: 'butt',
					lineWidth: parseInt(size/10),
					animate:false,
					size: size
				}).css('color', barColor);
				});
			  
				///////////////////////////////////////////
			
				//right & left position
				//show the user info on right or left depending on its position
				$('#user-profile-2 .memberdiv').on('mouseenter touchstart', function(){
					var $this = $(this);
					var $parent = $this.closest('.tab-pane');
			
					var off1 = $parent.offset();
					var w1 = $parent.width();
			
					var off2 = $this.offset();
					var w2 = $this.width();
			
					var place = 'left';
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) place = 'right';
					
					$this.find('.popover').removeClass('right left').addClass(place);
				}).on('click', function(e) {
					e.preventDefault();
				});
			
			
				///////////////////////////////////////////
			
				////////////////////
				//change profile
				$('[data-toggle="buttons"] .btn').on('click', function(e){
					var target = $(this).find('input[type=radio]');
					var which = parseInt(target.val());
					$('.user-profile').parent().addClass('hide');
					$('#user-profile-'+which).parent().removeClass('hide');
				});
				
				
				
				/////////////////////////////////////
				$(document).one('ajaxloadstart.page', function(e) {
					//in ajax mode, remove remaining elements before leaving page
					try {
						$('.editable').editable('destroy');
					} catch(e) {}
					$('[class*=select2]').remove();
				});
			});
		</script>
	</body>
</html>
