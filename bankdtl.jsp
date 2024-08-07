<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
    <jsp:include page="title.jsp" flush ="true"/>
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
        String bank=Gen.gettable(request.getParameter("S1"));
        String trx=Gen.gettable(request.getParameter("S2"));
        String titl="Spend Money";
        boolean add=false;
        if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){
            
            conn.setAutoCommit(false);        
            //cek itu dummy atau exist data
            if(msg.length()==0) msg=sgen.update(conn,"BANKDELETE",new String[]{gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S4"))});
            
            String x=gen.gettable(request.getParameter("S3"));
            int hx=gen.getInt(request.getParameter("CS"));
            for(int m=1;m<=hx;m++){
                String seq=gen.gettable(request.getParameter("A"+m));
                String acct=gen.gettable(request.getParameter("B"+m));
                String amt=gen.gettable(request.getParameter("D"+m));
                String NOTE=gen.gettable(request.getParameter("E"+m));
                String ref=gen.gettable(request.getParameter("F"+m));
                String SEQ="1";
                java.util.Vector vbank=sgen.getDataQuery(conn,"BANKMAXSEQ",new String[]{bank,gen.gettable(request.getParameter("P1"))});
                if(vbank.size()>0){
                    SEQ=gen.gettable(vbank.get(0));
                }
                //[Credit],[Debit],[TrxType],[RefNo],[Remarks] ,BANK,TrxDate,SEQ,refcode,Acct,NoteHeader
                String[] xc=new String[]{"0","0","B",ref,NOTE,gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("P1")),SEQ,gen.gettable(request.getParameter("P2")),acct,gen.gettable(request.getParameter("P5")),gen.gettable(request.getParameter("P4"))};
                if(x.equalsIgnoreCase("I")){
                      xc[1]=amt;//debet
                }else{
                      xc[0]=amt;//kredit
                }           
                seq=SEQ;
                
                if(msg.length()==0) msg=sgen.update(conn,"BANKDETAILADD",xc);
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"TRXBANKADD",bank+"|"+trx+"|"+SEQ+"|"});
            }
            if(msg.length()>0){
                conn.rollback();
                msg="(Save Failed!!"+msg+")";
            }else{
                conn.commit();
                add=false;
                msg="(Saved Successfully)";
            }     
            conn.setAutoCommit(true);
            
        }else if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DELETE")){
            conn.setAutoCommit(false);            
            if(msg.length()==0) msg=sgen.update(conn,"BANKDELETE",new String[]{gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S4"))});
            if(msg.length()>0){
                conn.rollback();
                msg="(DeleteFailed!!"+msg+")";
            }else{
                conn.commit();
                add=true;
                msg="(Delete Successfully)";
            }     
            conn.setAutoCommit(true);
        }else{
            conn.setAutoCommit(false);            
            int hx=gen.getInt(request.getParameter("CS"));
            for(int m=1;m<=hx;m++){
                if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DEL") && gen.getInt(request.getParameter("baris"))==m){
                    String seq=gen.gettable(request.getParameter("A"+m));
                    if(seq.length()>0){
                        if(msg.length()==0) msg=sgen.update(conn,"TRXBANKDELETE",new String[]{gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("P1")),seq});
                    }
                }
            }
            if(msg.length()>0){
                conn.rollback();
            }else{
                conn.commit();
            }     
            conn.setAutoCommit(true);

        }
        
        java.util.Vector vk=new java.util.Vector();
        java.util.Vector vkdtl=new java.util.Vector();
        
        boolean spend=true;
        String S3=gen.gettable(request.getParameter("S3"));
        if(gen.gettable(request.getParameter("S3")).equalsIgnoreCase("I")){
            spend=false;//receive
            titl="Receive Money";
        }
        String[] cond=new String[]{gen.gettable(request.getParameter("S1")),gen.gettable(request.getParameter("S2")),gen.gettable(request.getParameter("S4"))};
        String trxtype="";
        String p2=Gen.gettable(request.getParameter("P2")).trim();
        
        String to=gen.gettable(request.getParameter("P3")),mem=gen.gettable(request.getParameter("P5")),trf=gen.gettable(request.getParameter("P4"));
        if(!gen.gettable(request.getParameter("act")).equalsIgnoreCase("DELETE")){
            if(gen.gettable(request.getParameter("S3")).equalsIgnoreCase("I")){
                vkdtl=sgen.getDataQuery(conn,"TRXBANKINPUTI",cond);
            }else{
                vkdtl=sgen.getDataQuery(conn,"TRXBANKINPUTO",cond);
            }
            if(vkdtl.size()==0) add=true;
            if(!add){
                vk=sgen.getDataQuery(conn,"TRXBANKINPUT",cond);
                if(vk.size()>0){
                    if(request.getParameter("P5")==null) mem=gen.gettable(vk.get(2));
                    if(request.getParameter("P4")==null) trf=gen.gettable(vk.get(3));
                    if(gen.getformatdouble(vk.get(0))>0){
                        to=gen.gettable(vk.get(0));
                    }else if(gen.getformatdouble(vk.get(1))>0){
                        to=gen.gettable(vk.get(1));
                    }
                    trxtype=gen.gettable(vk.get(4)).trim();
                    add=false;
                }else{
                    add=true;
                }
            }else{
                if(to.length()==0)to="0";
            }
            if(request.getParameter("act")!=null){            
                int hx=gen.getInt(request.getParameter("CS"));
                java.util.Vector tmp=new java.util.Vector();
                for(int m=1;m<=hx;m++){
                    if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DEL") && gen.getInt(request.getParameter("baris"))==m){
                    }else{
                      tmp.addElement(request.getParameter("A"+m));
                      tmp.addElement(request.getParameter("B"+m));
                      tmp.addElement(request.getParameter("C"+m));
                      tmp.addElement(request.getParameter("E"+m));
                      tmp.addElement(request.getParameter("D"+m));
                      tmp.addElement(request.getParameter("F"+m));
                   }
                }
                vkdtl=tmp;
                if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("Add")){
                  for(int m=0;m<6;m++){
                      if(m==4) vkdtl.addElement("0");
                      else  vkdtl.addElement("");
                  }
                }
            }
        }else{
            to="0";
            mem="";
            trf="";
            trxtype="";
            p2="";
            add=true;
        }
        if(vkdtl.size()==0){
            for(int m=0;m<6;m++){
                if(m==4) vkdtl.addElement("0");
                else  vkdtl.addElement("");
            }
        }
        
        
         connMgr.freeConnection("db2", conn);
          connMgr.release();
          
        String view=Gen.gettable(request.getParameter("view"));
%>

	<body class="no-skin" onload="counttot()">
        <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
			         <form class="form-horizontal" name="BGA" method="POST" action="bankdtl.jsp?tp=<%=Gen.gettable(request.getParameter("tp"))%>" >
					<div class="page-content">
						<div class="page-header">
							<h1>
								<%=titl%> (<%=gen.gettable(request.getParameter("S1"))%>) <%=msg%>
							</h1>
						</div><!-- /.page-header -->
						<div class="row">
                            <div id="user-profile-3" >
                              <table id="simple-table" class="table  table-bordered table-hover">
  								<thead>
  									<tr><td colspan=4><b>Bank/Cash Information</b><td></tr>
  								</thead>                
  								<tbody>
                                      <tr>
                                          <td>*Date:</td><td nowrap>
                                            <input type="hidden" name="Y10" value="<%=gen.gettable(request.getParameter("Y10"))%>" />
                                            <input type="hidden" name="Y11" value="<%=gen.gettable(request.getParameter("Y11"))%>" />
                                            <input type="hidden" name="S1" value="<%=gen.gettable(request.getParameter("S1"))%>" />
                                            <%String p1=gen.gettable(request.getParameter("P1"));
                                            if(p1.length()==0) p1=Gen.getToday("dd-MM-yyyy");
                                              if(add){%>
                                                <input name="P1" class="input-medium date-picker"  id="P1" type="text" data-date-format="dd-mm-yyyy" value="<%=p1%>" placeholder="dd-mm-yyyy" /><i class="ace-icon fa fa-calendar"></i>
                                            <%}else{%>
                                                <input type="hidden" id="P1" name="P1"  value="<%=gen.gettable(request.getParameter("P1"))%>"/><b><%=gen.gettable(request.getParameter("P1"))%></b>
                                            <%}%>
                                            </td>
                                          <td>*REF ID#:</td><td>
                                            <%if(add){%>
                                          <input type="text" id="P2" size="15" maxlength="25" name="P2"  placeholder="ID #" value="<%=p2%>" <%=view%>/>                                          
                                            <%}else{%>
                                                <input type="hidden" id="P2" name="P2"  value="<%=Gen.gettable(request.getParameter("P2")).trim()%>"/><b><%=Gen.gettable(request.getParameter("P2")).trim()%></b>
                                            <%}%>
                                          </td>
                                      </tr>
                                      <tr>
                                          <td>*Total Amount:</td><td><input type="text" id="P3" maxlength="20" size="20" name="P3"  value="<%=gen.getNumberFormat(to,2)%>" <%=view%> disabled/>
                                        <input type="hidden" id="spend" name="spend"  value="<%=spend%>" <%=view%>/></td>
                                          <td>Payment Method:</td><td><select  name="P4" >
                                            <option></option>
                                            <option value="T" <%if(trf.equalsIgnoreCase("T")) out.print("selected");%>>Transfer</option>
                                            <option value="C" <%if(trf.equalsIgnoreCase("C")) out.print("selected");%>>Cash</option>
                                            </select> </td>
                                      </tr>
                                      <tr>
                                          <td>Memo:</td><td nowrap colspan=3><input type="hidden" name="CS" value="<%=(vkdtl.size()/6)%>"><textarea name="P5" rows=3 cols=40 tabindex="5"  <%=view%>><%=mem%></textarea></td>
  									</tr>
  								</tbody>
  							</table>
                         </div>
                        </div>
                        <div class="row">
                            <table id="Acct" class="table  table-bordered table-hover">
                				<thead>
                					<tr>
                                        <th>ACCOUNT</th>
                                        <th>DESCRIPTION</th>
                                        <th>REMARKS</th>                                                                        
                                        <th>AMOUNT</th>
                                        <th>REF. NO</th>
                                        <th>DEL</th>
                    				</tr>
                    				</thead>                
                    				<tbody>
                                    <%
                                    int hit=1;
                                    for(int i=0;i<vkdtl.size();i+=6){%>
                						<tr>
                							<td nowrap>
                          		              <input type="hidden" name="A<%=hit%>" value="<%=Gen.gettable(vkdtl.get(i)).trim()%>">
                          		              <input type="text" name="B<%=hit%>" size="5"  value="<%=Gen.gettable(vkdtl.get(i+1)).trim()%>" disabled>
                                              <%if(view.length()==0){%>
                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('ACCOUNT','B<%=hit%>','C<%=hit%>','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                              <%}%>
                                            </td>
                                            <td nowrap>
                                                <input type="text" name="C<%=hit%>"  size="20" value="<%=Gen.gettable(vkdtl.get(i+2)).trim()%>" disabled>
                                            </td>
                							<td>
                                                <input type="text"    id="E<%=hit%>" name="E<%=hit%>" maxlength="100" size="20" value="<%=Gen.gettable(vkdtl.get(i+3)).trim()%>" <%=view%>/>
                                            </td>
                							<td nowrap>
                                                <input type="text"   style="text-align:right;" id="D<%=hit%>" name="D<%=hit%>" onkeyup="counttot();" maxlength="15" size="12" value="<%=Gen.getNumberFormat(vkdtl.get(i+4),0)%>" <%=view%>/>
                                            </td>
                							<td>
                                                <input type="text"   id="F<%=hit%>" name="F<%=hit%>" maxlength="20" size="15" value="<%=Gen.gettable(vkdtl.get(i+5)).trim()%>" <%=view%>/>
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
                        <%if(!trxtype.equalsIgnoreCase("S") && !trxtype.equalsIgnoreCase("P")){%>
                      		<button class="btn btn-info" type="button" onclick="setsave('1');">
                      			<i class="ace-icon fa fa-check bigger-110"></i>
                      			Save
                      		</button>
                            <%}%>
                      		<button class="btn btn-info" type="button" onclick="onreturn();">
                      			<i class="ace-icon fa fa-return bigger-110"></i>
                      			Back
                      		</button>
                            <%if(!add){%>
                      		<button class="btn btn-info" type="button" onclick="onadd();">
                      			<i class="ace-icon fa fa-plus bigger-110"></i>
                      			Add New
                      		</button>
                              <%if(!trxtype.equalsIgnoreCase("S") && !trxtype.equalsIgnoreCase("P")){%>
                            		<button class="btn btn-info" type="button" onclick="ondelheader();">
                            			<i class="ace-icon fa fa-plus bigger-110"></i>
                            			Delete
                            		</button>
                                 <%}%>   
                            <%}%>
                        </div>
                        <%}%>
					</div><!-- /.page-content -->
                    <input type="hidden" name="act" value="">
                    <input type="hidden" name="baris" value="">
                    <input type="hidden" name="add" value="<%=add%>">
                    <input type="hidden" name="S1"  value="<%=Gen.gettable(request.getParameter("S1")).trim()%>" />
                    <input type="hidden" name="S2"  value="<%=Gen.gettable(request.getParameter("S2")).trim()%>" />
                    <input type="hidden" name="S3"  value="<%=S3%>" />
                    <input type="hidden" name="S4"  value="<%=Gen.gettable(request.getParameter("S4")).trim()%>" />
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
                location.href="banktransaction.jsp?tp=TRXBANK&Y12=<%=gen.gettable(request.getParameter("S1"))%>&Y10=<%=gen.gettable(request.getParameter("Y10"))%>&Y11=<%=gen.gettable(request.getParameter("Y11"))%>";
            }
            function onadd(parm){
                location.href="bankdtl.jsp?add=true&tp=<%=request.getParameter("tp")%>&S1=<%=gen.gettable(request.getParameter("S1"))%>&S2=<%=gen.gettable(request.getParameter("S2"))%>&Y10=<%=gen.gettable(request.getParameter("Y10"))%>&Y11=<%=gen.gettable(request.getParameter("Y11"))%>";
            }
            
        	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
        		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
        		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
        	}
            function  setsave(Parm){
                  if(document.BGA.P1.value==""){
                      alert("Transaction Date must be filled!");
                  }else if(document.BGA.P2.value==""){
                      alert("ID # must be filled!");
                  }else{
                     <%
                     int hc=1;
                     for(int i=0;i<vkdtl.size();i+=6){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.C<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     document.BGA.act.value="Save";
                      BGA.submit();
                  }
            }
            function  refresh(){                
                     document.BGA.act.value="Filter";
                      BGA.submit();
            }
            
            function counttot(){
                     var t1=0;
                     <%
                     int htc=1;
                     for(int i=0;i<vkdtl.size();i+=6){%>
                        t1+=Digit(document.BGA.D<%=htc%>.value);
                     <%htc++;
                     }%>
                     document.BGA.P3.value=NumberFormat(Math.round(t1));
            }
            function  ondel(Parm1){                
                     <%
                     hc=1;
                     for(int i=0;i<vkdtl.size();i+=6){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.C<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
                     document.BGA.baris.value=Parm1;
                     document.BGA.act.value="DEL";
                      BGA.submit();
            }
            function  ondelheader(){                
                     <%
                     hc=1;
                     for(int i=0;i<vkdtl.size();i+=6){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.C<%=hc%>.disabled=false;
                     <%hc++;
                     }%>

                     document.BGA.act.value="DELETE";
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
                     for(int i=0;i<vkdtl.size();i+=6){%>
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.C<%=hc%>.disabled=false;
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
