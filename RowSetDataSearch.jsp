<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page import="sun.jdbc.rowset.CachedRowSet" %>
<HTML>
<HEAD>
<%
		javax.servlet.http.HttpSession ses = request.getSession();   
		if (ses.getAttribute("User") == null){
%>
	<jsp:forward page="login.jsp"/>
<%
	}
        com.ysoft.General Gen = new com.ysoft.General(); 
//oper parameter link,Data,tt,cond
 	    com.ysoft.convertxml convert = new com.ysoft.convertxml();	
		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
		java.sql.Connection conn = connMgr.getConnection("db2");
	    com.ysoft.QueryClass queryclass = new com.ysoft.QueryClass();
 	    com.ysoft.subgeneral sGen = new com.ysoft.subgeneral();	
	    String dd =Gen.gettable(request.getParameter("Data"));
	    String conds=Gen.gettable(request.getParameter("cond"));
	    if (Gen.gettable(request.getParameter("INCLUDEINACTIVE")).equalsIgnoreCase("1")){
	    	dd = dd +"INACTIVE";
	    }
//  		 sql = Gen.getSQLStatement(Gen.gettable(request.getParameter("Srch")),dd,Gen.gettable(request.getParameter("cond")));
  		boolean issort=false;
  		if (Gen.gettable(request.getParameter("srt")).equalsIgnoreCase("true")){
  			issort=true;
  		}
	   if(Gen.gettable(request.getParameter("Type")).startsWith("TREATMENT") && Gen.gettable(request.getParameter("Data")).startsWith("TREATSELLALLW")) {
            if(Gen.gettable(request.getParameter("Z")).length()>0){
                java.util.Vector existcard=sGen.getDataQuery(conn,"MSTCARDBYID",new String[]{Gen.gettable(request.getParameter("Z")).trim()});
                if(existcard.size()>0){               
                    if(Gen.gettable(existcard.get(0)).trim().equalsIgnoreCase("F")){
                        dd="TREATSELLALLW2";
                        conds=Gen.gettable(request.getParameter("Z"))+",";
                    }
                }
            }
       }
	   if(Gen.gettable(request.getParameter("Type")).startsWith("SALES") && Gen.gettable(request.getParameter("Data")).startsWith("ITEMSELL")) {
            if(Gen.gettable(request.getParameter("T5")).length()==0){//ADA CARD
                dd="ITEMSELL";
                conds="";
            }
       }
//       System.out.println(">>"+dd+",conds="+conds);
	    String[] srch=null;
	    java.lang.String[] sql = sGen.getSQLStatement(Gen.gettable(request.getParameter("Srch")),dd,conds,issort,srch,Gen.getInt(request.getParameter("sort")));  		
  		if (sql==null){
  			sql = new String[5];
  		}
  		String judul=sql[4];
    	java.util.Vector title= Gen.getElement('+',sql[1]);
    	java.util.Vector sizetitle= Gen.getElement('+',sql[2]);
    	java.util.Vector dates= Gen.getElement(',',sql[3]);
	    java.lang.String nexturl = "",param_all=""; 
 	    if (Gen.gettable(request.getParameter("link")).trim().length()!=0)
    		nexturl = Gen.gettable(request.getParameter("link"))+"?";
	    java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =Gen.gettable(enu.nextElement());
             System.out.println(pr+"="+Gen.gettable(request.getParameter(pr)));
    		if (!pr.equalsIgnoreCase(Gen.gettable(request.getParameter("tt"))) && !pr.equalsIgnoreCase(Gen.gettable(request.getParameter("tt1"))) && !pr.equalsIgnoreCase("M"+Gen.gettable(request.getParameter("listinactive")))){
					if (pr.startsWith("M") || (pr.startsWith("D") && !pr.startsWith("Data"))){
					}else{
					   if (pr.startsWith("YT") &&  Gen.gettable(request.getParameter("Data")).equalsIgnoreCase("CUSTOMER")){
					   }else if (pr.startsWith("Y12") &&  Gen.gettable(request.getParameter("Data")).equalsIgnoreCase("CODETYPE")){
					   }else{
						    nexturl =nexturl+pr+"="+Gen.gettable(request.getParameter(pr))+"&";
						}
					}
	    	}
    		if (!pr.equalsIgnoreCase("INCLUDEINACTIVE") && !pr.startsWith("F") && !pr.equalsIgnoreCase("Srch") && !pr.equalsIgnoreCase("sort") && !pr.equalsIgnoreCase("Jml") && !pr.equalsIgnoreCase("action") && !pr.equalsIgnoreCase("batasnext") && !pr.equalsIgnoreCase("batasprev") && !pr.equalsIgnoreCase("from")  && !pr.equalsIgnoreCase("srt") && !pr.startsWith("Ch") && !pr.startsWith("M")){
    				if (pr.startsWith("D") && !pr.startsWith("Data")){//YT=type of customer
    				}else{
    				    if (pr.startsWith("YT") && Gen.gettable(request.getParameter("Data")).equalsIgnoreCase("CUSTOMER")){
					    }else if (pr.startsWith("Y12") &&  Gen.gettable(request.getParameter("Data")).equalsIgnoreCase("CODETYPE")){
    				    }else{
    		   			  param_all =param_all+pr+"="+Gen.gettable(request.getParameter(pr))+"&";
    		   			}
    				}
	   		}
	    }
 //System.out.println("nexturl="+nexturl);
    	//judul ="List of "+judul;
        if(dd.startsWith("CODEMASTER")){
            java.util.Vector ctype=Gen.getElement(',',conds);
            if(ctype.size()>0){
                String sq="Select codedesc from hrmst_codetype where codetype='"+Gen.gettable(ctype.get(0))+"'";
                java.util.Vector vks=queryclass.getDataQuery(conn,sq,1,new String[0]);
                if(vks.size()>0){
                    judul+=" ("+Gen.gettable(vks.get(0)).trim()+")";
                }
            }
            
        }
%>
<jsp:useBean id="Bankid" class="sun.jdbc.rowset.CachedRowSet" scope="request">
<%
System.out.println(sql[0]);
  Bankid.setCommand(sql[0]);
  Bankid.execute(conn);
  Bankid.first();
  connMgr.freeConnection("db2", conn);
  connMgr.release();
%>
</jsp:useBean>
<title><%=judul%></title>
<link rel='stylesheet prefetch' href='paysoft.css'>

<SCRIPT Language = "JavaScript" src="general.js"></SCRIPT>
<SCRIPT Language = "JavaScript" src="Convert.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
<script language = "JavaScript">
  
	function SetField(ArrayName, FieldName, Parm)
	{
 	  for(var i = 0; i < ArrayName.length; i++){
 	     if (ArrayName[i][1] == Parm){
           FieldName.value = ArrayName[i][0]; 
            BGA.submit();
         }
      }
      FieldName.value="";
	}
	function setAct(fieldcheck,fieldname){
		if (fieldcheck.checked){
			fieldname.value='1';
		   	location.href="RowSetDataSearch.jsp?<%=param_all%>Jml="+document.BGA.Jml.value+"&INCLUDEINACTIVE="+document.BGA.INCLUDEINACTIVE.value+"&Srch="+document.BGA.Srch.value;
		}else{
			fieldname.value='0';
		   	location.href="RowSetDataSearch.jsp?<%=param_all%>Jml="+document.BGA.Jml.value+"&INCLUDEINACTIVE="+document.BGA.INCLUDEINACTIVE.value+"&Srch="+document.BGA.Srch.value;
		}
	}
	function setAction(Parm){
		if (Parm=='Sort'){
			document.BGA.srt.value='true';
		}else if (Parm=='Sort0'){
			document.BGA.srt.value='false';
		}
		document.BGA.action.value=Parm;
	}
	function sort(Parm){
		document.BGA.sort.value=Parm;
		document.BGA.action.value="Change";
		BGA.submit();
	}
	function doCANCEL1() { //v3.0]
	  document.BGA.action.value = "Back"; 
	  document.BGA.submit(); 	
	}
	function closed(tt,tt1,tt2,tt3,tt4,tt5,tt6){
      <%
      String fo="BGA";
      if(Gen.gettable(request.getParameter("Type")).startsWith("REPFINANCE") && Gen.gettable(request.getParameter("Data")).startsWith("ACCOUNT")) {//khusus GL fix
        fo="BG";
      }
      %>
	 <%if (request.getParameter("tt")!=null){%>
	      window.opener.document.<%=fo%>.<%=Gen.gettable(request.getParameter("tt"))%>.value=tt;
    if(window.opener.document.<%=fo%>.S<%=Gen.gettable(request.getParameter("tt"))%>!=null){
	      window.opener.document.<%=fo%>.S<%=Gen.gettable(request.getParameter("tt"))%>.value=tt;
	    }
	  <%}%>
	 <%if (Gen.gettable(request.getParameter("tt1")).length()>0){%>
	      window.opener.document.<%=fo%>.<%=Gen.gettable(request.getParameter("tt1"))%>.value=tt1;
	      if(window.opener.document.<%=fo%>.S<%=Gen.gettable(request.getParameter("tt1"))%>!=null){
	      window.opener.document.<%=fo%>.S<%=Gen.gettable(request.getParameter("tt1"))%>.value=tt1;
	      }
	  <%}%>
	 <%if (Gen.gettable(request.getParameter("tt2")).length()>0){%>
	      window.opener.document.BGA.<%=Gen.gettable(request.getParameter("tt2"))%>.value=tt2;
	      if(window.opener.document.BGA.S<%=Gen.gettable(request.getParameter("tt2"))%>!=null){
	         window.opener.document.BGA.S<%=Gen.gettable(request.getParameter("tt2"))%>.value=tt2;
	      }
	  <%}%>
	 <%if (Gen.gettable(request.getParameter("tt3")).length()>0){%>
	     if(window.opener.document.BGA.<%=Gen.gettable(request.getParameter("tt3"))%>.value!=null){
	         window.opener.document.BGA.<%=Gen.gettable(request.getParameter("tt3"))%>.value=tt3;
             window.opener.document.getElementById("<%=Gen.gettable(request.getParameter("tt3"))%>").focus();            
	      }
	  <%}%>
	 <%if (Gen.gettable(request.getParameter("tt4")).length()>0){%>
	     if(window.opener.document.BGA.<%=Gen.gettable(request.getParameter("tt4"))%>.value!=null){
	         window.opener.document.BGA.<%=Gen.gettable(request.getParameter("tt4"))%>.value=tt4;
	      }
	  <%}%>
	 <%if (Gen.gettable(request.getParameter("tt5")).length()>0){%>
	     if(window.opener.document.BGA.<%=Gen.gettable(request.getParameter("tt5"))%>.value!=null){
	         window.opener.document.BGA.<%=Gen.gettable(request.getParameter("tt5"))%>.value=NumberFormat(Digit(tt5));
	      }
        if(window.opener.document.BGA.S<%=Gen.gettable(request.getParameter("tt5"))%>.value!=null){
    	      window.opener.document.BGA.S<%=Gen.gettable(request.getParameter("tt5"))%>.value=tt5;
    	    }
	  <%}%>
	 <%if (Gen.gettable(request.getParameter("tt6")).length()>0){%>
    	 if(window.opener.document.BGA.<%=Gen.gettable(request.getParameter("tt6"))%>.value!=null){
            window.opener.document.BGA.<%=Gen.gettable(request.getParameter("tt6"))%>.value=tt6;
      }
	  <%}%>
	<%if(Gen.gettable(request.getParameter("Type")).startsWith("SALES") && Gen.gettable(request.getParameter("Data")).startsWith("CARDPACKAGEMEMBER")) {%>
        window.opener.ref();        
  <%}%>
	<%if(Gen.gettable(request.getParameter("Type")).startsWith("TREATMENT") && Gen.gettable(request.getParameter("Data")).startsWith("MEMBER") && Gen.gettable(request.getParameter("tt")).startsWith("T3") ) {%>
        window.opener.ref();        
  <%}%>
	<%if(Gen.gettable(request.getParameter("Type")).startsWith("TREATMENT") && Gen.gettable(request.getParameter("Data")).startsWith("TREATSELL") ) {%>
        window.opener.counttot();        
  <%}%>
	<%if(Gen.gettable(request.getParameter("Type")).startsWith("SALES") && Gen.gettable(request.getParameter("Data")).startsWith("MEMBER")  && Gen.gettable(request.getParameter("tt")).startsWith("Y15") ) {%>
        window.opener.refresh();        
  <%}%>
<%if(Gen.gettable(request.getParameter("Type")).startsWith("TREATMENT") && Gen.gettable(request.getParameter("Data")).startsWith("CARDMEMBERTREATMENT")) {  %>
        window.opener.refresh();        
<%}%>        
	<%if(Gen.gettable(request.getParameter("Type")).startsWith("SALES") && (Gen.gettable(request.getParameter("Data")).startsWith("VOUCHER")||Gen.gettable(request.getParameter("Data")).startsWith("CARDMEMBERSALES"))) {%>
        window.opener.refresh();        
  <%}%>
	<%if(Gen.gettable(request.getParameter("Type")).startsWith("REPFINANCE") && Gen.gettable(request.getParameter("Data")).startsWith("ACCOUNT")) {%>
        window.opener.ref();        
  <%}%>
	<%if(Gen.gettable(request.getParameter("Type")).startsWith("AP") && Gen.gettable(request.getParameter("Data")).startsWith("VENDOR")) {%>
        window.opener.refresh();        
  <%}%>
	<%if((Gen.gettable(request.getParameter("Type")).startsWith("POLIST") ||Gen.gettable(request.getParameter("Type")).startsWith("PURCHASELIST")||Gen.gettable(request.getParameter("Type")).startsWith("QUOLIST")||Gen.gettable(request.getParameter("Type")).startsWith("INVOICE"))&& dd.startsWith("ITEM")){%>
        window.opener.Tot1();
	<%}%>
	 if(window.opener.document.BGA.ST!=null) window.opener.document.BGA.ST.value=tt2;
	      window.close();
	}
</script>

<META name="GENERATOR" content="Microsoft FrontPage 4.0">
</HEAD>
<BODY leftmargin="0" topmargin="0">
<FORM name="BGA" METHOD="POST" ACTION="RowSetDataSearch.jsp?<%=param_all%>">
<p><font color=#3da7b3 size="2" > &nbsp;</p>
 <p><b><font color=#3da7b3 size="6" face="Times New Roman, Arial, Helvetica, sans-serif"> &nbsp;&nbsp;<%=judul%>
<CENTER>
<%
 	 	boolean isprev = false,isnext=false;
		String form = "MM-dd-yyyy";
		if (Gen.gettable(ses.getAttribute("TxtFormatdate")).startsWith("D"))
			form="dd-MM-yyyy";
		java.text.SimpleDateFormat sdfdate = new java.text.SimpleDateFormat(form);
	    int jumlah =Gen.getInt(request.getParameter("Jml")),tungrecord=0;
	    if (jumlah==0) jumlah=20;
	    int tungnext=0,tungprev=0;
		if ( Gen.gettable(request.getParameter("action")).equalsIgnoreCase(" > ")) {
		    tungrecord=Gen.getInt(request.getParameter("batasnext"));
	  	} else if ( Gen.gettable(request.getParameter("action")).equalsIgnoreCase(" < ")) {
		    tungrecord=Gen.getInt(request.getParameter("batasprev"));
	  	}
	    int j=1,countin=0,count=tungrecord;
	    if (tungrecord==0 && Bankid.size()>0){
			countin++;
		}
		if (Bankid.size()>1){
		   	while(Bankid.next()){
	 	  		if (j>=tungrecord){//sampai record yg mau ditampilkan
	  	 			if (countin<jumlah){
						countin++;
					}
				}
		  		if (j>tungrecord+countin || Bankid.isLast()){
 	 				break;
  				}
	   		  	j++;
		  	}
   		 }
		 count=count+countin;
  	  	 Bankid.first();
	 	 j=1;
	 	 countin=0;

%>
<TABLE width="100%" cellSpacing=1 cellPadding=0  border=0><!-- width=660--><!-- Begin Top Ads -->
  <TBODY>
  <TR>
   <TD width="85%" class=mainwindow vAlign=top height=400>
<TABLE width="100%" border=0 align="center">
  <TBODY>
    <TR>
      <TD width="100%">
      	<TABLE width="100%" border=0 align="center">
    	<TR><TD >
<%if (dd.startsWith("STOCK")){%>
     	 <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Cabang:
	              <select name="c1" size="1" onChange="SetField(BRC,F2, c1.options[c1.selectedIndex].text)" disabled>
	                            <option></option>		
	      	  		<%String f2=Gen.gettable(ses.getAttribute("TxtBranch")).trim();
	      	  		 /* if (Gen.gettable(request.getParameter("F2")).trim().length()>0) f2=Gen.gettable(request.getParameter("F2")).trim();
	   		      		for(int k =0;k<BRC.size();k=k+2){
	   		      			if (f2.equalsIgnoreCase(Gen.gettable(BRC.get(k)).trim())){
	  					  		  out.println("<option selected>"+Gen.gettable(BRC.get(k+1))+"</option>");    
	  						     }else{
	  					  		  out.println("<option>"+Gen.gettable(BRC.get(k+1))+"</option>");    
	  						     }
			      		  }      
	          		*/%>	
	              </select>
				  <input type="hidden" name="F2" value = "<%=f2%>">
        </font>
<%}%>
     </TD></TR>
    <TR>
      <TD width="100%"><input type="text" name="Srch" value="<%=Gen.gettable(request.getParameter("Srch"))%>" size="20" tabindex="4" >&nbsp;&nbsp;<input type="submit" value="Search" name="act"  tabindex="5" onClick="setAction('Search')">
      </TD>
     </TR>
    <TR> 
      <TD width="100%" >
<%
	if (Gen.gettable(request.getParameter("listinactive")).equalsIgnoreCase("true")){
%>
		<font size="2" face="Verdana, Arial, Helvetica, sans-serif"><input type="checkbox" name="incact" value="ON" <% if (Gen.gettable(request.getParameter("INCLUDEINACTIVE")).equalsIgnoreCase("1")) out.print("checked"); %> onClick="setAct(incact,INCLUDEINACTIVE)">
        <strong><%if(dd.startsWith("SUPPLIER")){%>Termasuk Black Market<%}else{%>Semua<%}%></strong></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%
	}
%>        
      <input type="text" name="Jml" value="<%=jumlah%>" size="3" maxlength="2" tabindex="1" >
		<INPUT TYPE="submit" NAME="act" tabindex="1" VALUE="R"  onclick="setAction('R')">&nbsp;&nbsp;
<% 
   if (tungrecord!=0) isprev=true;//first time call
   if (count<0)	isprev = false;//if prev
   if (count < Bankid.size()) isnext = true;//if have next data

   out.print("<INPUT TYPE=\"submit\" NAME=\"act\" VALUE=\" < \"  tabindex=\"2\"  onclick=\"setAction(' < ')\"");
   if (!isprev) out.print("disabled");
   out.print(">&nbsp;&nbsp;");
   out.print("<INPUT TYPE=\"submit\" NAME=\"act\" VALUE=\" > \"  tabindex=\"3\"  onclick=\"setAction(' > ')\"");
   if (!isnext) out.print("disabled");
   out.print(">&nbsp;&nbsp;");%>
      <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><%=count%> / <%=Bankid.size()%></font>
      </TD>
    </TR>
  </table>
      </TD>
    </TR>
    <tr> 
      <td> 
	  <table align="left" border="no" cellpadding="0" cellspacing="0" >
    <tr  bgcolor=#3da7b3>
    <%
    	int i=0;
    	for(i=0;i<title.size();i++){%>
          <td width="<%=Gen.getnumber(sizetitle.get(i))%>" align="center" ><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color=white><a href="javascript:sort('<%=i+""%>')"><%=Gen.gettable(title.get(i))%></a></font></td>
    <%}%>
    </tr>
    <%
    int rem=1;
    if (tungrecord==0){
    	if (Bankid.size()>0){
    		String firstdata ="";
  			if (dates.size()>0){
  				if (1==Gen.getInt(dates.get(0))){
  					   if (Bankid.getDate(1)!=null) firstdata =sdfdate.format(Bankid.getDate(1));
  				}else{
  					   firstdata=Gen.gettable(Bankid.getString(1)).trim();
  				}
  			}else {
  				firstdata=Gen.gettable(Bankid.getString(1)).trim();
  			}
				String tmb="",tmb3="",tmb4="",tmb5="",tmb6="";
  				if(Gen.gettable(request.getParameter("Type")).startsWith("CODEMASTERLIST") && dd.startsWith("CODETYPE")){
                    if(Gen.gettable(Bankid.getString(3)).trim().equalsIgnoreCase("TRUE")){
      				    tmb=Gen.gettable(ses.getAttribute("TxtEmployer")).trim();
                    }else{
      				    tmb="";
                    }
          		}
				String tmp="";
        if (Gen.gettable(request.getParameter("tt1")).length()>0) tmp=Gen.gettable(Bankid.getString(2)).trim();
        if (Gen.gettable(request.getParameter("tt2")).length()>0) tmb=Gen.gettable(Bankid.getString(3)).trim();
        if(Gen.gettable(request.getParameter("Type")).startsWith("SALES") && Gen.gettable(request.getParameter("Data")).startsWith("TREAT")){
              if (Gen.gettable(request.getParameter("tt3")).length()>0) tmb3=""+Gen.getInt(Bankid.getString(4));
        }
        if(Gen.gettable(request.getParameter("Type")).startsWith("SALES") &&Gen.gettable(request.getParameter("Data")).startsWith("ITEM")){
              if (Gen.gettable(request.getParameter("tt3")).length()>0) tmb3=""+Gen.getInt(Bankid.getString(5));
        }
        if(dd.startsWith("ITEM")&&(Gen.gettable(request.getParameter("Type")).startsWith("QUOLIST")||Gen.gettable(request.getParameter("Type")).startsWith("POLIST")||Gen.gettable(request.getParameter("Type")).startsWith("PURCHASELIST")||Gen.gettable(request.getParameter("Type")).startsWith("INVOICE"))){
          if (Gen.gettable(request.getParameter("tt2")).length()>0) tmb=Gen.gettable(Bankid.getString(2)).trim();
          if (Gen.gettable(request.getParameter("tt3")).length()>0) tmb3=Gen.gettable(Bankid.getString(3)).trim();
          if (Gen.gettable(request.getParameter("tt4")).length()>0) tmb4=Gen.getNumberFormat(Bankid.getString(6),0);
          if (Gen.gettable(request.getParameter("tt5")).length()>0){
            if(Gen.gettable(request.getParameter("Type")).startsWith("QUOLIST")){
                tmb5=Gen.gettable(Bankid.getString(5)).trim();
            }else if(Gen.gettable(request.getParameter("Type")).startsWith("POLIST")){
                tmb5=Gen.gettable(Bankid.getString(6)).trim();
            }else if(Gen.gettable(request.getParameter("Type")).startsWith("PURCHASELIST")){
                tmb5=Gen.gettable(Bankid.getString(6)).trim();
            }else if(Gen.gettable(request.getParameter("Type")).startsWith("INVOICE")){
                tmb5=Gen.gettable(Bankid.getString(5)).trim();
            }
          } 
        }
				String cls="tdRowMedium";
				if(rem%2!=0) cls="tdRowLight";
   		  out.println("<tr  class="+cls+" ><td  width=\""+Gen.getnumber(sizetitle.get(0))+"\" align=\"left\" ><font face=\"Verdana, Arial, Helvetica, sans-serif\" size=\"2\">&nbsp;<a href=\"javascript:closed('"+firstdata+"','"+tmp+"','"+tmb+"','"+tmb3+"','"+tmb4+"','"+tmb5+"','"+tmb6+"')\">"+firstdata+"</a>");
  			if (title.size()>1){
  			  	for(int k=2;k<=title.size();k++){
							String al="left";
							if(Gen.gettable(title.get(k-1)).trim().startsWith("RATE")||Gen.gettable(title.get(k-1)).trim().startsWith("TOTAL")||Gen.gettable(title.get(k-1)).trim().endsWith("PRICE")){
								al="right";
							}
					  		out.print("</font></td><td width=\""+Gen.getnumber(sizetitle.get(k-1))+"\" align=\""+al+"\"><font face=\"Verdana, Arial, Helvetica, sans-serif\" size=\"2\">");
    						boolean in=false;
    						for(int s=0;s<dates.size();s++){//cek date
    							if (k==Gen.getInt(dates.get(s))){
    								if (Bankid.getDate(k)!=null)
    									out.print(sdfdate.format(Bankid.getDate(k)));
    								else
    									out.print("");
    								in= true;
    								break;
    							}
    						}//for(int s=
    						if (!in){
								if(Gen.gettable(title.get(k-1)).trim().startsWith("RATE")||Gen.gettable(title.get(k-1)).trim().startsWith("TOTAL")||Gen.gettable(title.get(k-1)).trim().endsWith("PRICE")){
									out.print("&nbsp;"+Gen.getNumberFormat(Bankid.getString(k),0));						
								}else{
									out.print("&nbsp;"+Gen.getfortable(Bankid.getString(k)).trim());						
								}
							}
   		  		}//endfor
		  	}//end title
			  out.print("</font></td></tr>");
			  countin++;
			  rem++;
		  }//end bankid.size
	}//end tungrecord==0
	if (Bankid.size()>1){
	   	while(Bankid.next()){
	   		if (j>=tungrecord){//sampai record yg mau ditampilkan
	   			if (countin<jumlah){
  			  		String firstdata ="";
    					if (dates.size()>0){
    						if (1==Gen.getInt(dates.get(0))){
    							if (Bankid.getDate(1)!=null)
    								firstdata =sdfdate.format(Bankid.getDate(1));
    						}else{
    							firstdata=Gen.gettable(Bankid.getString(1)).trim();
    						}
    					}else {
    						firstdata=Gen.gettable(Bankid.getString(1)).trim();
    					}
    					String tmb="",tmb3="",tmb4="",tmb5="",tmb6="";
                      //  System.out.println(Gen.gettable(request.getParameter("Type"))+","+dd.startsWith("CODETYPE")+","+Gen.gettable(Bankid.getString(3)).trim());
      				if(Gen.gettable(request.getParameter("Type")).startsWith("CODEMASTERLIST") && dd.startsWith("CODETYPE")){
                        if(Gen.gettable(Bankid.getString(3)).trim().equalsIgnoreCase("true")){
          				    tmb=Gen.gettable(ses.getAttribute("TxtEmployer")).trim();
                        }else{
          				    tmb="";
                        }
              		}
				String tmp="";
				if (Gen.gettable(request.getParameter("tt1")).length()>0) tmp=Gen.gettable(Bankid.getString(2)).trim();
         if (Gen.gettable(request.getParameter("tt2")).length()>0) tmb=Gen.gettable(Bankid.getString(3)).trim();
        if(Gen.gettable(request.getParameter("Type")).startsWith("SALES") && Gen.gettable(request.getParameter("Data")).startsWith("TREAT")){
              if (Gen.gettable(request.getParameter("tt3")).length()>0) tmb3=""+Gen.getInt(Bankid.getString(4));
        }
        if(Gen.gettable(request.getParameter("Type")).startsWith("SALES") && Gen.gettable(request.getParameter("Data")).startsWith("ITEM")){
              if (Gen.gettable(request.getParameter("tt3")).length()>0) tmb3=""+Gen.getInt(Bankid.getString(5));
        }
       if(dd.startsWith("ITEM")&&(Gen.gettable(request.getParameter("Type")).startsWith("QUOLIST")||Gen.gettable(request.getParameter("Type")).startsWith("POLIST")||Gen.gettable(request.getParameter("Type")).startsWith("PURCHASELIST")||Gen.gettable(request.getParameter("Type")).startsWith("INVOICE"))){
          if (Gen.gettable(request.getParameter("tt2")).length()>0) tmb=Gen.gettable(Bankid.getString(2)).trim();
          if (Gen.gettable(request.getParameter("tt3")).length()>0) tmb3=Gen.gettable(Bankid.getString(3)).trim();
          if (Gen.gettable(request.getParameter("tt4")).length()>0) tmb4=Gen.getNumberFormat(Bankid.getString(6),0);
          if (Gen.gettable(request.getParameter("tt5")).length()>0){
            if(Gen.gettable(request.getParameter("Type")).startsWith("QUOLIST")){
                tmb5=Gen.gettable(Bankid.getString(5)).trim();
            }else if(Gen.gettable(request.getParameter("Type")).startsWith("POLIST")){
                tmb5=Gen.gettable(Bankid.getString(6)).trim();
            }else if(Gen.gettable(request.getParameter("Type")).startsWith("PURCHASELIST")){
                tmb5=Gen.gettable(Bankid.getString(6)).trim();
            }else if(Gen.gettable(request.getParameter("Type")).startsWith("INVOICE")){
                tmb5=Gen.gettable(Bankid.getString(5)).trim();
            }
          } 
        }
				String cls="tdRowMedium";
				if(rem%2!=0) cls="tdRowLight";
			   		  out.println("<tr class="+cls+" ><td  width=\""+Gen.getnumber(sizetitle.get(0))+"\" align=\"left\" ><font face=\"Verdana, Arial, Helvetica, sans-serif\" size=\"2\">&nbsp;<a href=\"javascript:closed('"+firstdata+"','"+tmp+"','"+tmb+"','"+tmb3+"','"+tmb4+"','"+tmb5+"','"+tmb6+"')\">"+firstdata+"</a>");
					    if (title.size()>1){
    			  			for(int k=2;k<=title.size();k++){
    			   		  String rap="";
    			   		  if(Gen.gettable(title.get(k-1)).trim().startsWith("TANGGAL")) rap="nowrap";
									String al="left";
									if(Gen.gettable(title.get(k-1)).trim().startsWith("RATE")||Gen.gettable(title.get(k-1)).trim().startsWith("TOTAL")||Gen.gettable(title.get(k-1)).trim().endsWith("PRICE")){
										al="right";
									}
    			  					out.print("</font></td><td "+rap+" width=\""+Gen.getnumber(sizetitle.get(k-1))+"\" ><p "+rap+" align=\""+al+"\"><font  face=\"Verdana, Arial, Helvetica, sans-serif\" size=\"2\">");
        							boolean in=false;
        							for(int s=0;s<dates.size();s++){//cek date
        								if (k==Gen.getInt(dates.get(s))){
        									if (Bankid.getDate(k)!=null)
        										out.print(sdfdate.format(Bankid.getDate(k)));
        									else
        										out.print("&nbsp;");
        									in= true;
        									break;
        								}
        							}
        							if (!in){
										if(Gen.gettable(title.get(k-1)).trim().startsWith("RATE")||Gen.gettable(title.get(k-1)).trim().startsWith("TOTAL")||Gen.gettable(title.get(k-1)).trim().endsWith("PRICE")){
											out.print("&nbsp;"+Gen.getNumberFormat(Bankid.getString(k),0));						
										}else{
											 out.print("&nbsp;"+Gen.getfortable(Bankid.getString(k)).trim());						
										}
									 }
    					  	}//for(int k=2;k<=titl
		  		    }//endif (title.size()>1)
					    out.print("</font></td></tr>");
					    countin++;
					    rem++;
		  		}//countin<jumlah
		  	}//j>=tungrecord
	  		if (j>tungrecord+countin){
 	 			  break;
  			}
	  		if(Bankid.isLast()){
	  			break;
	  		}
   		  j++;
   		}//while(Bankid.next()){
	}//if (Bankid.size()>1){
  tungnext = tungrecord+countin;
  if (jumlah!=countin){
	    tungprev = tungrecord-jumlah;
  }else{
	    tungprev = tungrecord-countin;
	}
  		%>   
 </table>
 </td>
 </tr>
 </table>
   </td>
    </tr>
  </TBODY>
</TABLE>
 
<INPUT TYPE="hidden" NAME="ACT" VALUE="<%if (request.getParameter("prev") != null) out.print("prev");else out.print("next");%>"/>
<INPUT TYPE="hidden" NAME="INCLUDEINACTIVE" VALUE="<%=Gen.gettable(request.getParameter("INCLUDEINACTIVE"))%>"/>
<INPUT TYPE="hidden" NAME="batasnext" VALUE="<%=tungnext%>"/>
<INPUT TYPE="hidden" NAME="batasprev" VALUE="<%=tungprev%>"/>
<INPUT TYPE="hidden" NAME="srt" VALUE="<%=Gen.gettable(request.getParameter("srt"))%>"/>
<INPUT TYPE="hidden" NAME="sort" VALUE="<%=Gen.gettable(request.getParameter("sort"))%>"/>
<INPUT TYPE="hidden" NAME="from" value="list"/>
<INPUT TYPE="hidden" NAME="n1" value=""/>
<INPUT TYPE="hidden" NAME="n2" value=""/>
<INPUT TYPE="hidden" NAME="n3" value=""/>
<INPUT TYPE="hidden" NAME="n4" value=""/>
<INPUT TYPE="hidden" NAME="action"/>
</CENTER></FORM>
</BODY>
</HTML>
