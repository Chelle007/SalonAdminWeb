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
        String y1=Gen.gettable(request.getParameter("S1")),y2=Gen.gettable(request.getParameter("S2"));
        if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){
                                                                      //*T1=[JobNo],[Seq],*T2=[TrxDate],*T3=[Acct],T5=[DebetKredit],T8=[RefNo1],*T7=[Code],*T6=[TypeJob],*T4=[JobStatus],[USD],[SGD],T9 AMT[IDR] ,T10[Rate],T11 CURR,[Comment],ST3=[Desc],T12[RefNo2],
//                                                            T13=16 [Vendor],T14=17 [BillTo],T15=18 [Customer],T16=[MYOBNO],T17=[MYOBAMT],T18=[MYOBSTATUS]

            if(Gen.gettable(request.getParameter("add")).equalsIgnoreCase("true")){//Umum
                java.util.Vector exist=sgen.getDataQuery(conn,"JOBMAXSEQ",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("T1"))});
                String seq="1";
//            [TrxDate],[Acct],[DebetKredit],[RefNo1],[Code],[TypeJob],[JobStatus],[USD],[SGD],[IDR],[Rate],[Comment],[Desc],[RefNo2],[Vendor],[BillTo],[Customer],[MYOBNO],[MYOBAMT],[MYOBSTATUS],ERCODE,JOBNO,SEQ
                if(exist.size()>0) seq=""+(gen.getInt(exist.get(0))+1);
                String usd="0";String sgd="0";
                String idr=gen.gettable(request.getParameter("T9"));
                if(Gen.gettable(request.getParameter("T11")).equalsIgnoreCase("SGD")){
                    sgd=gen.gettable(request.getParameter("T9"));
                    idr="";
                }
                if(Gen.gettable(request.getParameter("T11")).equalsIgnoreCase("USD")){
                    usd=gen.gettable(request.getParameter("T9"));
                    idr="";
                }
                y1=Gen.gettable(request.getParameter("T1"));
                y2=seq;
                String rate=gen.gettable(request.getParameter("T10"));
                if(gen.getformatdouble(rate)==0 && !Gen.gettable(request.getParameter("T11")).equalsIgnoreCase("IDR")){
                    java.util.Vector vkrate=sgen.getDataQuery(conn,"RATEJOB",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("T11")),Gen.gettable(request.getParameter("T2"))});
                    if(vkrate.size()>0){
                        rate=gen.gettable(vkrate.get(0));
                    }   
                    
                }
                msg=sgen.update(conn,"JOBADD",new String[]{gen.gettable(request.getParameter("T2")),gen.gettable(request.getParameter("T3")),gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T8")),gen.gettable(request.getParameter("T7")),gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T4")),usd,sgd,idr,rate,gen.gettable(request.getParameter("T21")),gen.gettable(request.getParameter("ST3")),gen.gettable(request.getParameter("T12")),gen.gettable(request.getParameter("T13")),gen.gettable(request.getParameter("T14")),gen.gettable(request.getParameter("T15")),gen.gettable(request.getParameter("T16")),gen.gettable(request.getParameter("T17")),gen.gettable(request.getParameter("T18")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("T1")),seq});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"JOBADD",gen.gettable(request.getParameter("T1"))+"|"+seq+"|"});
            }else{//update
                String seq=gen.gettable(request.getParameter("S2"));
                String usd="0";String sgd="0";
                String idr=gen.gettable(request.getParameter("T9"));
                if(Gen.gettable(request.getParameter("T11")).equalsIgnoreCase("SGD")){
                    sgd=gen.gettable(request.getParameter("T9"));
                    idr="";
                }
                if(Gen.gettable(request.getParameter("T11")).equalsIgnoreCase("USD")){
                    usd=gen.gettable(request.getParameter("T9"));
                    idr="";
                }
                String rate=gen.gettable(request.getParameter("T10"));
                if(gen.getformatdouble(rate)==0 && !Gen.gettable(request.getParameter("T11")).equalsIgnoreCase("IDR")){
                    java.util.Vector vkrate=sgen.getDataQuery(conn,"RATEJOB",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("T11")),Gen.gettable(request.getParameter("T2"))});
                    if(vkrate.size()>0){
                        rate=gen.gettable(vkrate.get(0));
                    }   
                }
                
                msg=sgen.update(conn,"JOBUPDATE",new String[]{gen.gettable(request.getParameter("T2")),gen.gettable(request.getParameter("T3")),gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T8")),gen.gettable(request.getParameter("T7")),gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T4")),usd,sgd,idr,rate,gen.gettable(request.getParameter("T21")),gen.gettable(request.getParameter("ST3")),gen.gettable(request.getParameter("T12")),gen.gettable(request.getParameter("T13")),gen.gettable(request.getParameter("T14")),gen.gettable(request.getParameter("T15")),gen.gettable(request.getParameter("T16")),gen.gettable(request.getParameter("T17")),gen.gettable(request.getParameter("T18")),gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("T1")),seq});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"JOBUPDATE",gen.gettable(request.getParameter("T1"))+"|"+seq+"|"});
            }
          if(msg.length()>0){
              msg="(Save Failed!!"+msg+")";
          }else{
              msg="(Saved Successfully)";
          }     
        }
        
        //[JobNo],[Seq],[TrxDate],[Acct],[DebetKredit],[RefNo1],[Code],[TypeJob],[JobStatus],[USD],[SGD],[IDR] ,[Rate],[Comment],[Desc],[RefNo2],[Vendor],[BillTo],[Customer],[MYOBNO],[MYOBAMT],[MYOBSTATUS]
        String[] cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y1,y2};
        java.util.Vector vk=sgen.getDataQuery(conn,"JOBDETAIL",cond);
        String add="false";
        if(vk.size()==0){
            for(int m=0;m<23;m++)vk.addElement("");
            vk.setElementAt(gen.getToday("dd-MM-yyyy"),2);
            add="true";
        }
        String[] condx=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y1,"SALES"};
        java.util.Vector sales=sgen.getDataQuery(conn,"JOBDETAIL1",condx);
        condx[2]="COSTS";
        java.util.Vector cost=sgen.getDataQuery(conn,"JOBDETAIL1",condx);
        //
        //[Acct],Description,[DebetKredit],[RefNo1],[RefNo2],case when usd!=0 then (usd*rate) when sgd!=0 then sgd*rate else idr end as amt,cv.codedesc,bi.codedesc,cu.codede
        java.util.Vector vks=sgen.getDataQuery(conn,"FINDCODE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),"VDR",gen.gettable(vk.get(16))});
        String vendor="";
        if(vks.size()>0)vendor=gen.gettable(vks.get(0)).trim();
        vks=sgen.getDataQuery(conn,"FINDCODE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),"BILL",gen.gettable(vk.get(17))});
        String billto="";
        if(vks.size()>0)billto=gen.gettable(vks.get(0)).trim();
        vks=sgen.getDataQuery(conn,"FINDCODE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),"CUST",gen.gettable(vk.get(18))});
        String customer="";
        if(vks.size()>0)customer=gen.gettable(vks.get(0)).trim();
        java.util.Vector CODE=sgen.getDataQuery(conn,"JOBDETAILCODE",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
         connMgr.freeConnection("db2", conn);
          connMgr.release();
          
        String view=Gen.gettable(request.getParameter("view"));
%>

	<body class="no-skin">
        <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1>
								Job <%=msg%>
							</h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div id="user-profile-3" class="user-profile row">
										<div class="col-sm-offset-1 col-sm-10">
												<div class="tabbable">
													<ul class="nav nav-tabs padding-16">
														<li class="active">
															<a data-toggle="tab" href="#edit-basic">
																<i class="green ace-icon fa fa-pencil-square-o bigger-125"></i>
																Job Information
															</a>
														</li>
                                                        <%if(Gen.gettable(vk.get(0)).trim().length()!=0){%>
														<li>
															<a data-toggle="tab" href="#edit-sales">
																<i class="blue ace-icon fa fa-file-o bigger-125"></i>
																Sales
															</a>
														</li>
														<li>
															<a data-toggle="tab" href="#edit-cost">
																<i class="blue ace-icon fa fa-file-o bigger-125"></i>
																Cost
															</a>
														</li>
                                                        <%}%>
													</ul>

													<div class="tab-content profile-edit-tab-content">                                                    
														<div id="edit-basic" class="tab-pane in active">
            											<form class="form-horizontal" name="BGA" method="POST" action="jobdetail.jsp?tp=<%=Gen.gettable(request.getParameter("tp"))%>" >
															<h4 class="header blue bolder smaller">Job Information</h4>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">*Job No : </label>																
																<label class="control-label">
                                                                <%if(Gen.gettable(vk.get(0)).trim().length()==0){%>
																	<input type="text" id="T1" maxlength="10" size="10" name="T1"  placeholder="Job No" value="<%=Gen.gettable(vk.get(0)).trim()%>" <%=view%>/>
                                                                <%}else{%>
																	<input type="text" id="T1" maxlength="10" size="10" name="T1"  placeholder="Job No" value="<%=Gen.gettable(vk.get(0)).trim()%>" disabled/>
                                                                <%}%>
                                                                    &nbsp;&nbsp;Date:<input class="input-medium date-picker" name="T2"  id="T2" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(2)).trim()%>" placeholder="dd-mm-yyyy" /><i class="ace-icon fa fa-calendar"></i>
                                                                    &nbsp;&nbsp;Type:<select name="T6" <%=view%>>
                                                                	<option value="EXP" <%if(Gen.gettable(vk.get(7)).trim().equalsIgnoreCase("EXP")) out.print("selected");%>>EXP</option>
                                                                	<option value="IMP" <%if(Gen.gettable(vk.get(7)).trim().equalsIgnoreCase("IMP")) out.print("selected");%>>IMP</option>
                                                                    <option value="TAX" <%if(Gen.gettable(vk.get(7)).trim().equalsIgnoreCase("TAX")) out.print("selected");%>>TAX</option>
                                                                    <option value="BAN" <%if(Gen.gettable(vk.get(7)).trim().equalsIgnoreCase("BAN")) out.print("selected");%>>BAN</option>
                                                                    </select>                                                                    
                                                                </B></label>
															</div>
															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">*Account : </label>
																<label class="control-label">
                                              		              <input type="text" name="T3"  size="10" value="<%=Gen.gettable(vk.get(3))%>" disabled>
                                              		              <input type="text" name="ST3" size="40" maxlength="60" tabindex="5"  value="<%=Gen.gettable(vk.get(14)).trim()%>" disabled>
                                                                  <%if(view.length()==0){%>
                                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('ACCOUNT','T3','ST3','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                                                  <%}%>
															</div>
															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">*Status : </label>
																<label class="control-label">
      															<select name="T4" <%=view%>>
                                                                	<option value="SALES" <%if(Gen.gettable(vk.get(8)).trim().equalsIgnoreCase("SALES")) out.print("selected");%>>SALES</option>
                                                                	<option value="COSTS" <%if(Gen.gettable(vk.get(8)).trim().equalsIgnoreCase("COSTS")) out.print("selected");%>>COSTS</option>
                                                                    </select>
      															<select name="T5" <%=view%>>
                                                                	<option value="DB" <%if(Gen.gettable(vk.get(4)).trim().equalsIgnoreCase("DB")) out.print("selected");%>>DEBIT</option>
                                                                	<option value="CR" <%if(Gen.gettable(vk.get(4)).trim().equalsIgnoreCase("CR")) out.print("selected");%>>CREDIT</option>
                                                                    </select>
                                                                   </label>
															</div>
                                                            <h4 class="header blue bolder smaller">Detail Information</h4>
															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">Code : </label>
                                                                <label class="control-label">
      															<select name="T7" <%=view%>>
                                                                    <option></option>
                                                                    <%for(int m=0;m<CODE.size();m+=1){%>
                                                                	<option value="<%=gen.gettable(CODE.get(m))%>" <%if(Gen.gettable(vk.get(6)).trim().equalsIgnoreCase(gen.gettable(CODE.get(m)).trim())) out.print("selected");%>><%=gen.gettable(CODE.get(m)).trim()%></option>
                                                                    <%}%>
                                                                </select>
																&nbsp;&nbsp;Ref. No 1:<input type="text" id="T8" size="20" maxlength="100" name="T8"  placeholder="Ref. No." value="<%=Gen.gettable(vk.get(5)).trim()%>" <%=view%>/>
                                                                &nbsp;&nbsp;Ref. No 2:<input type="text" id="T12" size="20" maxlength="100" name="T12"  placeholder="Ref. No." value="<%=Gen.gettable(vk.get(15)).trim()%>" <%=view%>/>
                                                                </label>
															</div>
															<div class="space-4"></div>
															<div class="form-group">
                                                                <%
                                                                String cur="IDR";
                                                                String amt=gen.getNumberFormat(vk.get(11),0);
                                                                if(gen.getformatdouble(vk.get(9))>0){
                                                                    cur="USD";
                                                                    amt=gen.getNumberFormat(vk.get(9),2);
                                                                }else if(gen.getformatdouble(vk.get(10))>0){
                                                                    cur="USD";
                                                                    amt=gen.getNumberFormat(vk.get(10),2);
                                                                }
                                                                %>
																<label class="col-sm-3 control-label no-padding-right ">*Amount : </label>
                                                                <label class="control-label">
                                                                <input type="text" id="T9" name="T9" maxlength="10" size="10" value="<%=amt%>" <%=view%>/>
                                                                &nbsp;&nbsp;Rate:<input type="text" id="T10" name="T10" maxlength="8" size="6" value="<%=gen.getNumberFormat(vk.get(12),0)%>" <%=view%>/>
    															&nbsp;&nbsp;Currency:<select name="T11">
                                                                    <option value="IDR" <%if(cur.trim().equalsIgnoreCase("IDR")) out.print("selected");%>>IDR</option>
                                                                  	<option value="USD" <%if(cur.trim().equalsIgnoreCase("USD")) out.print("selected");%>>USD</option>
                                                                  	<option value="SGD" <%if(cur.trim().equalsIgnoreCase("SGD")) out.print("selected");%>>SGD</option>
                                                                  	<option value="CNY" <%if(cur.trim().equalsIgnoreCase("CNY")) out.print("selected");%>>CNY</option>
                                                                  	<option value="EUR" <%if(cur.trim().equalsIgnoreCase("EUR")) out.print("selected");%>>EUR</option>
                                                                </select>    
                                                                
                                                                </label>
                                                             </div>                                                              
  															<div class="space-4"></div>
  															<div class="form-group">
  																<label class="col-sm-3 control-label no-padding-right ">Vendor : </label>
                                                                <label class="control-label">
                                              		              <input type="hidden" name="T13" value="<%=Gen.gettable(vk.get(16))%>">
                                              		              <input type="text" name="ST13" size="40" maxlength="60" tabindex="10"  value="<%=vendor%>" disabled>
                                                                  <%if(view.length()==0){%>
                                       				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('VENDOR','T13','ST13','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                                                  <%}%>
                                                                </label>
  															</div>                  
  															<div class="form-group">
  																<label class="col-sm-3 control-label no-padding-right ">Bill To : </label>
                                                                <label class="control-label">
                                              		              <input type="hidden" name="T14" value="<%=Gen.gettable(vk.get(17))%>">
                                              		              <input type="text" name="ST14" size="40" maxlength="60" tabindex="10"  value="<%=billto%>" disabled>
                                                                  <%if(view.length()==0){%>
                                       				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('BILLTO','T14','ST14','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                                                  <%}%>
                                                                </label>
  															</div>                  
  															<div class="form-group">
  																<label class="col-sm-3 control-label no-padding-right ">Customer : </label>
                                                                <label class="control-label">
                                              		              <input type="hidden" name="T15" value="<%=Gen.gettable(vk.get(18))%>">
                                              		              <input type="text" name="ST15" size="40" maxlength="60" tabindex="10"  value="<%=customer%>" disabled>
                                                                  <%if(view.length()==0){%>
                                       				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('CUSTOMER','T15','ST15','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                                                  <%}%>
                                                                </label>
  															</div>                  
  															<div class="space-4"></div>
  															<div class="form-group">
  																<label class="col-sm-3 control-label no-padding-right ">Comment/Remarks : </label>
                                                                    <input type="text" id="T21" name="T21" maxlength="200" size="60" value="<%=gen.gettable(vk.get(13)).trim()%>" <%=view%>/>
  															</div>                  
                                                            <h4 class="header blue bolder smaller">MYOB Information</h4>
															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">MYOB No. : </label>
                                                                <label class="control-label">
																<input type="text" id="T16" size="20" maxlength="100" name="T16"  placeholder="MYOB No." value="<%=Gen.gettable(vk.get(19)).trim()%>" <%=view%>/>
                                                                &nbsp;&nbsp;Amount:<input type="text" id="T17" size="20" maxlength="100" name="T17"  placeholder="Ref. No." value="<%=Gen.getNumberFormat(vk.get(20))%>" <%=view%>/>
    															&nbsp;&nbsp;Status:<select name="T18">
                                                                    <option value="OPEN" <%if(Gen.gettable(vk.get(21)).trim().trim().equalsIgnoreCase("OPEN")) out.print("selected");%>>OPEN</option>
                                                                  	<option value="CLOSED" <%if(Gen.gettable(vk.get(21)).trim().trim().equalsIgnoreCase("CLOSED")) out.print("selected");%>>CLOSED</option>
                                                                </select>    
                                                                </label>
															</div>
                                                            <%if(view.length()==0){%>
                                                            <div class="space-4"></div>
            												<div class="clearfix form-actions">
            													<div class="col-md-offset-3 col-md-9">
            														<button class="btn btn-info" type="button" onclick="setsave('1');">
            															<i class="ace-icon fa fa-check bigger-110"></i>
            															Save
            														</button>
            													</div>
            												</div>
                                                            <%}%>
                                                                  <input type="hidden" name="act" value="">
                                                                  <input type="hidden" name="add" value="<%=add%>">
                                                                  <input type="hidden" name="S1" value="<%=gen.gettable(request.getParameter("S1"))%>">
                                                                  <input type="hidden" name="S2" value="<%=gen.gettable(request.getParameter("S2"))%>">
                                                                  <input type="hidden" name="x" value="1">
                  											</form>
														</div>
                                                        
														<div id="edit-sales" class="tab-pane">
                                                            <table id="simple-table" class="table  table-bordered table-hover">
                												<thead>
                													<tr>
                                                                        <th>Account</th>
                                                                        <th>Description</th>
                                                                        <th>Debit/Credit</th>
                                                                        <th>Ref. No.</th>                                                                        
                                                                        <th>Amount</th>                                                                        
                                                                        <th>Vendor</th>
                                                                        <th>Bill To</th>
                                                                        <th>Customer</th>
                													</tr>
                												</thead>                
                												<tbody>
                                                                    <%for(int i=0;i<sales.size();i+=9){%>
                                                						<tr>
                                                							<td ><%=Gen.gettable(sales.get(i))%></td>
                                                							<td><%=Gen.gettable(sales.get(i+1)).trim()%></td>
                                                                            <td><%=Gen.gettable(sales.get(i+2)).trim()%></td>
                                                                            <td><%=Gen.gettable(sales.get(i+3)).trim()%></td>
                                                                            <td align=right><%=Gen.getNumberFormat(sales.get(i+5),2)%></td>
                                                                            <td><%=Gen.gettable(sales.get(i+6)).trim()%></td>
                                                                            <td><%=Gen.gettable(sales.get(i+7)).trim()%></td>
                                                                            <td><%=Gen.gettable(sales.get(i+8)).trim()%></td>
                                                   						</tr>
                                                                    <%}%>
                												</tbody>
                											</table>
														</div>
														<div id="edit-cost" class="tab-pane">
                                                            <table id="simple-table" class="table  table-bordered table-hover">
                												<thead>
                													<tr>
                                                                        <th>Account</th>
                                                                        <th>Description</th>
                                                                        <th>Debit/Credit</th>
                                                                        <th>Ref. No. 1</th>
                                                                        <th>Ref. No. 2</th>                                                                             
                                                                        <th>Amount</th>                                                                        
                                                                        <th>Vendor</th>
                                                                        <th>Bill To</th>
                                                                        <th>Customer</th>
                													</tr>
                												</thead>                
                												<tbody>
                                                                    <%for(int i=0;i<cost.size();i+=9){%>
                                                						<tr>
                                                							<td ><%=Gen.gettable(cost.get(i))%></td>
                                                							<td><%=Gen.gettable(cost.get(i+1)).trim()%></td>
                                                                            <td><%=Gen.gettable(cost.get(i+2))%></td>
                                                                            <td><%=Gen.gettable(cost.get(i+3)).trim()%></td>
                                                                            <td><%=Gen.gettable(cost.get(i+4)).trim()%></td>
                                                                            <td align=right><%=Gen.getNumberFormat(cost.get(i+5),2)%></td>
                                                                            <td t><%=Gen.gettable(cost.get(i+6)).trim()%></td>
                                                                            <td><%=Gen.gettable(cost.get(i+7)).trim()%></td>
                                                                            <td><%=Gen.gettable(cost.get(i+8)).trim()%></td>
                                                   						</tr>
                                                                    <%}%>
                												</tbody>                												
                											</table>
														</div>
													</div>
												</div>
										</div><!-- /.span -->
									</div><!-- /.user-profile -->
								</div>

								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->
					</div><!-- /.page-content -->
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
    
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
      //*T1=[JobNo],[Seq],*T2=[TrxDate],*T3=[Acct],T5=[DebetKredit],T8=[RefNo1],*T7=[Code],*T6=[TypeJob],*T4=[JobStatus],[USD],[SGD],T9 AMT[IDR] ,T10[Rate],T11 CURR,[Comment],ST3=[Desc],T12[RefNo2],
//                                                            T13=16 [Vendor],T14=17 [BillTo],T15=18 [Customer],T16=[MYOBNO],T17=[MYOBAMT],T18=[MYOBSTATUS]

            function  setsave(Parm){
                if(Parm=="1"){
                  if(document.BGA.T1.value==""){
                      alert("JobNo must be Filled!");
                  }else if(document.BGA.T2.value==""){
                      alert("Transaction Date must be filled!");
                  }else if(document.BGA.T3.value==""){
                      alert("Account must be filled");
                  }else{
                     document.BGA.T1.disabled=false;
                     document.BGA.T13.disabled=false;
                     document.BGA.T14.disabled=false;
                     document.BGA.T15.disabled=false;
                     document.BGA.T3.disabled=false;
                     document.BGA.ST3.disabled=false;
                     document.BGA.act.value="Save";
                      BGA.submit();
                  }
                }else{
                     document.B.act.value="Save";
                      B.submit();
                }
            }
            function  refresh(){                
                     document.BS.act.value="Filter";
                      BS.submit();
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
