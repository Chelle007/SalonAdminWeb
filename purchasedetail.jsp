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
        com.ysoft.QueryClass query = new com.ysoft.QueryClass();
        java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =Gen.gettable(enu.nextElement());
          //  System.out.println(pr+"="+Gen.gettable(request.getParameter(pr)));
        }        

  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");

        String msg="";
        String y1=Gen.gettable(request.getParameter("S1"));
        String supp=gen.gettable(request.getParameter("T3"));
        if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){
            conn.setAutoCommit(false);
            String t2=Gen.gettable(request.getParameter("T2"));//trxdate
            java.util.Vector vkst=gen.getElement('-',t2+"-");
            String yr=gen.gettable(vkst.get(2)).substring(2,4);
            String mth=gen.gettable(vkst.get(1));
            if(mth.length()==1) mth="0"+mth;
            if(Gen.gettable(request.getParameter("add")).equalsIgnoreCase("true")){//Umum
                if(gen.gettable(request.getParameter("T3")).length()==0){//supplier
                    java.util.Vector exist=sgen.getDataQuery(conn,"FINDSUPPLIER",new String[]{gen.gettable(request.getParameter("ST8"))});
                    if(exist.size()>0){
                        supp=gen.gettable(exist.get(0)).trim();//find supplier using contact_no
                    }else{
                        exist=sgen.getDataQuery(conn,"PURCHASESUPPLIER",new String[0]);
                        String pref="S";
                        String seq="";
                        if(exist.size()>0){
                            if(gen.gettable(exist.get(0)).trim().length()>0){   
                              String nextno=gen.gettable(exist.get(0));
                              int g=gen.getInt(nextno)+1;
                              seq=g+"";
                              while(seq.length()<3){
                                  seq="0"+seq;
                              }
                            }else{
                                seq="001";
                            }
                        }else{
                            seq="001";
                        }
                        supp=pref+seq;
                    }
                    if(msg.length()==0) msg=sgen.update(conn,"PURCHASESUPPLIERADD",new String[]{supp,gen.gettable(request.getParameter("ST3")),gen.gettable(request.getParameter("ST8"))});
                    if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"PURCHASESUPPLIERADD",supp+"|"});
   
                }
//PURCHASE_DATE,SUPPLIER_ID,BANK_ID,TOTAL_PURCHASE_PRICE,TOTAL_COST_PRICE,TOTAL_DISCOUNT_AMOUNT,remark,paiddate,PAYMENT_DUE_DATE,PURCHASE_ID) VALUES (?,?,?,?,
                String jb="P"+yr+mth+"%";
                java.util.Vector exist=sgen.getDataQuery(conn,"PURCHASEMAX",new String[]{jb});
                String pref="P"+yr+mth;
                String seq="";
                if(exist.size()>0){
                      String nextno=gen.gettable(exist.get(0));
                      int g=gen.getInt(nextno)+1;
                      seq=g+"";
                      while(seq.length()<4){
                          seq="000"+seq;
                      }
                }else{
                    seq="0001";
                }
                y1=pref+seq;
                if(msg.length()==0) msg=sgen.update(conn,"PURCHASEADD",new String[]{gen.gettable(request.getParameter("T2")), supp,gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T7")),gen.gettable(request.getParameter("T8")),gen.gettable(request.getParameter("T9")),gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T11")),gen.gettable(request.getParameter("T4")),y1+""});                           
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"PURCHASEADD",y1+"|"});
            }else{//update
                if(msg.length()==0) msg=sgen.update(conn,"PURCHASEUPDATE",new String[]{gen.gettable(request.getParameter("T2")), supp,gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T7")),gen.gettable(request.getParameter("T8")),gen.gettable(request.getParameter("T9")),gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T11")),gen.gettable(request.getParameter("T4")),y1+""});                           
                   if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"PURCHASEUPDATE",y1+"|"});
            }
            if(msg.length()==0){
                if(msg.length()==0) msg=sgen.update(conn,"PURCHASEDETAILDELETE",new String[]{y1});
                if(msg.length()==0) msg=sgen.update(conn,"BANKREFDELETE",new String[]{y1});

                java.util.Vector exist=sgen.getDataQuery(conn,"BANKMAXSEQ",new String[]{gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T2"))});
                String seqmax="1";
                if(exist.size()>0){
                    seqmax=gen.gettable(exist.get(0)).trim();//
                }
                if(msg.length()==0) msg=sgen.update(conn,"BANKADD",new String[]{gen.gettable(request.getParameter("T10")),"0","P","",gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T2")),seqmax,y1});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"BANKADD",gen.gettable(request.getParameter("T2"))+"|"+seqmax+"|"});

                if(msg.length()==0) {
                
                    java.util.Vector item=sgen.getDataQuery(conn,"PURCHASEDETAILITEM",new String[0]);
                    int hx=gen.getInt(request.getParameter("CT"));
                     for(int m=1;m<=hx;m++){
                        if(gen.gettable(request.getParameter("A"+m)).length()>0){
                            int qtys=0,unit=0;
                            for(int mm=0;mm<item.size();mm+=2){
                                if(gen.gettable(request.getParameter("A"+m)).trim().equalsIgnoreCase(gen.gettable(item.get(mm)).trim())){
                                    qtys=gen.getInt(request.getParameter("C"+m))*gen.getInt(item.get(mm+1));
                                    //unit=gen.getInt(item.get(mm+1));
                                }
                            }
                            int hargaunit=(int)Math.round(gen.getInt(query.getDataInt(request.getParameter("E"+m)))/qtys);
                           if(msg.length()==0 ) msg=sgen.update(conn,"PURCHASEPRICEITEM",new String[]{hargaunit+"",gen.gettable(request.getParameter("A"+m))});                           
                           if(msg.length()==0 ) msg=sgen.update(conn,"PURCHASEDETAILADD",new String[]{m+"",y1, gen.gettable(request.getParameter("A"+m)),gen.gettable(request.getParameter("C"+m)),""+qtys,gen.gettable(request.getParameter("E"+m)),gen.gettable(request.getParameter("F"+m))});                           
                           //PURCHASE_DETAIL_ID,PURCHASE_ID,ITEM_ID,QUANTITY,QUANTITYSTOCK,PURCHASE_PRICE,DISCOUNT_AMOUNT) v
                            if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"PURCHASEDETAILADD",y1+"|"+m+"|"+gen.gettable(request.getParameter("A"+m))+"|"});
                        }
                    }
                }
            }
            if(msg.length()>0){
                conn.rollback();
                msg="(Save Failed!!"+msg+")";
            }else{
                conn.commit();
                msg="(Saved Successfully)";
            }     
            conn.setAutoCommit(true);
        }
        
        String[] cond=new String[]{y1};
        java.util.Vector vk=sgen.getDataQuery(conn,"PURCHASEHEADER",cond);
        String add="false";
        if(vk.size()==0){
            for(int m=0;m<13;m++)vk.addElement("");
            vk.setElementAt(gen.getToday("dd-MM-yyyy"),1);
            vk.setElementAt("0",4);
            vk.setElementAt("0",5);
            vk.setElementAt("0",6);
            vk.setElementAt(gen.gettable(request.getParameter("T3")),2);
            vk.setElementAt(gen.gettable(request.getParameter("ST3")),8);
            add="true";
        }else{
            supp=gen.gettable(vk.get(2));
        }
        
        
        java.util.Vector TREAT=new java.util.Vector();
        if(!add.equalsIgnoreCase("true")) TREAT=sgen.getDataQuery(conn,"PURCHASEDETAIL",cond);
        // PURCHASE_DETAIL_ID, PURCHASE_DETAIL.ITEM_ID,ITEM_DESC,PURCHASE_DETAIL.QUANTITY ,QUANTITYSTOCK,PURCHASE_DETAIL.PURCHASE_PRICE,DISCOUNT_AMOUNT from
        if(request.getParameter("act")!=null && !Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){             
              vk.setElementAt(y1,0);
              vk.setElementAt(gen.gettable(request.getParameter("T2")),1);
              vk.setElementAt(gen.gettable(request.getParameter("T3")),2);
              vk.setElementAt(gen.gettable(request.getParameter("T5")),3);
              vk.setElementAt(gen.gettable(request.getParameter("T7")),4);
              vk.setElementAt(gen.gettable(request.getParameter("T8")),5);
              vk.setElementAt(gen.gettable(request.getParameter("T9")),6);
              vk.setElementAt(gen.gettable(request.getParameter("T6")),7);
              vk.setElementAt(gen.gettable(request.getParameter("ST3")),8);
              vk.setElementAt(gen.gettable(request.getParameter("ST5")),9);
               vk.setElementAt(gen.gettable(request.getParameter("T4")),10);
              vk.setElementAt(gen.gettable(request.getParameter("T11")),11);
              vk.setElementAt(gen.gettable(request.getParameter("ST8")),12);
            int hx=gen.getInt(request.getParameter("CT"));
            java.util.Vector tmp2=new java.util.Vector();
            for(int m=1;m<=hx;m++){
                if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("DELTreat") && gen.getInt(request.getParameter("baris"))==m){
                }else{
                  tmp2.addElement("");
                  tmp2.addElement(request.getParameter("A"+m));
                  tmp2.addElement(request.getParameter("B"+m));
                  tmp2.addElement(request.getParameter("C"+m));
                  tmp2.addElement(request.getParameter("D"+m));
                  tmp2.addElement(request.getParameter("E"+m));
                  tmp2.addElement(request.getParameter("F"+m));
                }
            }
            TREAT=tmp2;
            if(gen.gettable(request.getParameter("act")).equalsIgnoreCase("AddTreat")){
              for(int m=0;m<7;m++){
                  if(m>=3) TREAT.addElement("0");
                  else  TREAT.addElement("");
              }
            }
        }
        
        if(TREAT.size()==0){
              for(int m=0;m<7;m++){
                  if(m>=3) TREAT.addElement("0");
                  else  TREAT.addElement("");
              }
        }
        String dtf=gen.getToday("dd-MM-yyyy");
         connMgr.freeConnection("db2", conn);
          connMgr.release();
          
        String view=Gen.gettable(request.getParameter("view"));
%>

	<body class="no-skin" <%if(gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false") && Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){%>onload="window.close()"<%}else{%> onload="counttot()"<%}%>>
    <%if(!gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false")){%>
        <jsp:include page="menu.jsp" flush ="true"/>
    <%}%>
			<div class="main-content">
				<div class="main-content-inner">
			         <form class="form-horizontal" name="BGA" method="POST" action="purchasedetail.jsp?tp=<%=Gen.gettable(request.getParameter("tp"))%>" >
					<div class="page-content">
						<div class="page-header">
							<h1>
							Purchase <%=msg%>&nbsp;&nbsp;&nbsp;&nbsp;	
							</h1>
						</div><!-- /.page-header -->
						<div class="row">
                            <div id="user-profile-3" >
                              <table id="simple-table" class="table  table-bordered table-hover">
  								<thead>
  									<tr><td colspan=6><b>Purchase Header Information</b><td></tr>
  								</thead>    
  								<tbody>
                                      <tr>
                                          <td nowrap>Purchase ID:</td><td><input type="text" id="T1" size="15" maxlength="10" name="T1"  value="<%=Gen.gettable(vk.get(0)).trim()%>" disabled/></td>
                                          <td>Date:</td><td><input name="T2"   class="input-medium date-picker"  id="T2" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(1)).trim()%>" placeholder="dd-mm-yyyy" /><i class="ace-icon fa fa-calendar"></i></TD>
                                          <td>Remark:</td><td><input type="text" id="T6" size="35" maxlength="40" name="T6"  placeholder="Remark" value="<%=Gen.gettable(vk.get(7)).trim()%>" <%=view%>/></td>
                                       </tr>
                                      <tr>
                                          <td >Supplier:</td><td nowrap><input type="hidden" name="T3" value="<%=Gen.gettable(vk.get(2))%>"><input type="text" name="ST3" size="20" maxlength="60" tabindex="10"  value="<%=Gen.gettable(vk.get(8)).trim()%>" disabled>
                                      <%if(view.length()==0){%>
                                        <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('SUPPLIER','T3','ST3','','')">
                                        <%}%>
                                         </td><td>Supplier Phone:</td><td> <input type="text" name="ST8" size="10" maxlength="15" tabindex="10"  value="<%=Gen.gettable(vk.get(12)).trim()%>" placeholder="Phone No">
                                          </td>
                                          <td >Bank Id:</td><td nowrap ><input type="hidden" name="T5" value="<%=Gen.gettable(vk.get(3))%>"><input type="text" name="ST5" size="10" maxlength="60" tabindex="10"  value="<%=Gen.gettable(vk.get(9)).trim()%>" disabled>
                                              <%if(view.length()==0){%><input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('BANK','T5','ST5','','')"><%}%>
                                          </td>
                                      </tr>
                                     <tr>
                                          <td >Paid Date:</td><td nowrap>
                                          <input name="T11"   class="input-medium date-picker"  id="T11" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(11)).trim()%>" placeholder="dd-mm-yyyy" /><i class="ace-icon fa fa-calendar"></i> </td>
                                          <td >Payment Due Date:</td><td nowrap >
                                          <input name="T4"   class="input-medium date-picker"  id="T4" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(10)).trim()%>" placeholder="dd-mm-yyyy" /><i class="ace-icon fa fa-calendar"></i> </td>
                                          <td>Total Purchase:</td><td nowrap><input type="text"  style="text-align:right;" id="T7" size="14" maxlength="14" name="T7"  value="<%=Gen.getNumberFormat(vk.get(4),0)%>" <%=view%> disabled/></td>
                                      </tr>
                                      <%
                                      int tf=gen.getInt(vk.get(4))+gen.getInt(vk.get(5))-gen.getInt(vk.get(6));
                                      %>
                                      <tr>
                                          <td>Total Cost:</td><td nowrap><input type="text"  style="text-align:right;" id="T8" size="14" maxlength="14" name="T8"  value="<%=Gen.getNumberFormat(vk.get(5),0)%>" <%=view%> onchange="counttot()"/></td>
                                          <td>Total Discount Amount:</td><td nowrap><input type="text"  style="text-align:right;" id="T9" size="14" maxlength="14" name="T9"  value="<%=Gen.getNumberFormat(vk.get(6),0)%>"  onchange="counttot()"<%=view%> /></td>
                                          <td>Total Net Purchase:</td><td nowrap><input type="text"  style="text-align:right;" id="T10" size="14" maxlength="14" name="T10"  value="<%=Gen.getNumberFormat(tf+"",0)%>" <%=view%> disabled/></td>
                                      </tr>
  								</tbody>
  							</table>
                         </div>
                        </div>
                        <div class="row">
                            <table id="treat" class="table  table-bordered table-hover">
                				<thead>
                					<tr>
                                        <th colspan=7>Purchasing Detail Information<input type="hidden" name="CT" value="<%=(TREAT.size()/7)%>"></th>
                    				</tr>
                					<tr>
                                        <th>SEQ</th>
                                        <th>ITEM</th>
                                        <th>QUANTITY</th>
                                        <th>PRICE</th>       
                                        <th>DISC ITEM</th>       
                                        <th>TOTAL</th>       
                                        <th>DEL</th>
                    				</tr>
                    				</thead>                
                    				<tbody>
                                    <%
                                    int hit=1;
                                    for(int i=0;i<TREAT.size();i+=7){//
                                        int tt=gen.getInt(TREAT.get(3+i))*(gen.getInt(TREAT.get(5+i))-gen.getInt(TREAT.get(6+i)));
                                    %>
                						<tr>
                							<td nowrap> <%=hit+""%></td>                     		             
                          		            <td nowrap>  <input type="text" name="A<%=hit%>" size="5"  value="<%=Gen.gettable(TREAT.get(i+1)).trim()%>" disabled>
                          		              <input type="text" name="B<%=hit%>" size="20"  value="<%=Gen.gettable(TREAT.get(i+2)).trim()%>" disabled>
                                              <%if(view.length()==0){%>
                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('ITEM','A<%=hit%>','B<%=hit%>','','');">
                                              <%}%>
                                            </td>
                							<td nowrap><input type="text" name="C<%=hit%>" size="5"  value="<%=Gen.gettable(TREAT.get(i+3)).trim()%>" onchange="count(C<%=hit%>,E<%=hit%>,F<%=hit%>,G<%=hit%>)"></td>
                         		            <td nowrap>  
                          		              <input type="text" name="E<%=hit%>" size="20"  value="<%=Gen.getNumberFormat(TREAT.get(i+5),0)%>"  onchange="count(C<%=hit%>,E<%=hit%>,F<%=hit%>,G<%=hit%>)">
                                            </td>
                							<td nowrap>
                                                <input type="text" name="F<%=hit%>" maxlength="10" size="8" value="<%=Gen.getNumberFormat(TREAT.get(i+6),0)%>" <%=view%>  onchange="count(C<%=hit%>,E<%=hit%>,F<%=hit%>,G<%=hit%>)"/>
                                            </td>
                							<td nowrap>
                                                <input type="text" name="G<%=hit%>" maxlength="10" size="8" value="<%=Gen.getNumberFormat(tt,0)%>" <%=view%> disabled/>
                                            </td>
                                            <td nowrap><button class="btn btn-xs btn-danger"  onclick="ondel('Treat','<%=hit%>')">
  												<i class="ace-icon fa fa-trash-o bigger-120"></i></button>
                                            </td>
                   						</tr>
                                    <%hit++;
                                    }%>
                                    <tr><td colspan=6></td><td><a href="javascript:subm('AddTreat')"><img width=20 height=20 src=image/plus.gif></a></td></tr>
                				</tbody>
                			</table>
                        </div>
                      <%if(view.length()==0){%>
                        <div class="row" align=center>
                      		<button class="btn btn-info" type="button" onclick="setsave('1');">
                      			<i class="ace-icon fa fa-check bigger-110"></i>
                      			Save
                      		</button>
                            <%if(!gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false")){%>                            
                        		<button class="btn btn-info" type="button" onclick="onreturn();">
                        			<i class="ace-icon fa fa-return bigger-110"></i>
                        			Back
                        		</button>
                              <%if(!add.equalsIgnoreCase("true")){%>
                        		<button class="btn btn-info" type="button" onclick="onadd();">
                        			<i class="ace-icon fa fa-plus bigger-110"></i>
                        			Add New
                        		</button>
                              <%}%>
                            <%}%>
                        </div>
                        <%}%>
					</div><!-- /.page-content -->
                      <%if(view.length()==0){%>
                      
                      <div class="clearfix form-actions">
                      	<div class="col-md-offset-3 col-md-9">
                      	</div>
                      </div>
                        <%}%>
                    <input type="hidden" name="act" value="">
                    <input type="hidden" name="baris" value="">
                    <input type="hidden" name="add" value="<%=add%>">
                    <input type="hidden" name="S1" value="<%=gen.gettable(request.getParameter("S1"))%>">
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

	function setradio(Parm,avalue)
	{
  		Parm.value = avalue;
        
	}
    function ondel(Parm){
        if(confirm("Delete Selected Record?","Delete")){
           document.BGA.act.value="DEL";
           document.BGA.S2.value=Parm;
            BGA.submit();
        }
    }
    function onreturn(){
        location.href="purchase.jsp?tp=TREATMENT";
    }
    function onadd(){
        location.href="purchasedetail.jsp?add=true&tp=<%=request.getParameter("tp")%>";
    }
    
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}

            function  setsave(Parm){
                if(Parm=="1"){
                  if(document.BGA.T2.value==""){
                      alert("Purchase Date must be filled!");
                  }else if(document.BGA.T3.value==""){
                      alert("Supplier must be filled!");
                  }else if(document.BGA.T5.value==""){
                      alert("Bank Id must be filled!");
                  }else{
                     opendis();
                     document.BGA.act.value="Save";
                      BGA.submit();
                  }
                }else{
                     document.B.act.value="Save";
                      B.submit();
                }
            }
            function opendis(){
                     document.BGA.T1.disabled=false;
                     document.BGA.ST3.disabled=false;
                     document.BGA.ST5.disabled=false;
                     document.BGA.T10.disabled=false;
                     document.BGA.T7.disabled=false;
                     <%
                     int hc=1;
                     for(int i=0;i<TREAT.size();i+=7){%>
                        document.BGA.A<%=hc%>.disabled=false;
                        document.BGA.B<%=hc%>.disabled=false;
                        document.BGA.G<%=hc%>.disabled=false;
                     <%hc++;
                     }%>
            }
            function  refresh(){                
                     opendis();            
                     document.BGA.act.value="Filter";
                      BGA.submit();
            }
            function counttot(){
                     var t1=0,t2=0;
                     <%
                     int htc=1;
                     for(int i=0;i<TREAT.size();i+=7){%>
                        if(document.BGA.G<%=htc%>.value!='') t1+=Digit(document.BGA.G<%=htc%>.value);
                        if(document.BGA.F<%=htc%>.value!='') t2+=Digit(document.BGA.F<%=htc%>.value);
                     <%htc++;
                     }%>
                     var t3=Digit(document.BGA.T8.value);
                     if(document.BGA.T9.value=='' ||document.BGA.T9.value=='0'){
                         document.BGA.T9.value=NumberFormat(Math.round(t2));                         
                     }else{
                         t2=Digit(document.BGA.T9.value);
                     }
                     document.BGA.T7.value=NumberFormat(Math.round(t1));
                     document.BGA.T10.value=NumberFormat(Math.round(t1+t3-t2));
            }
            function count(Parm1,Parm3,Parm4,Parm5){
                    Parm5.value=NumberFormat(Digit(Parm1.value)*(Digit(Parm3.value))-Digit(Parm4.value));
                    counttot();
            }
            function  ondel(Parm,Parm1){    
                     opendis();            
                     document.BGA.baris.value=Parm1;
                     document.BGA.act.value="DEL"+Parm;
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
                     opendis();            
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
