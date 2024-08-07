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
        String y1=Gen.gettable(request.getParameter("S1")),y2=Gen.gettable(request.getParameter("S2")),y3=Gen.gettable(request.getParameter("S3"));
        java.util.Vector databef=new java.util.Vector();
        if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){
//T2=trxdate,//T3=[tpContainer],T1=[ContNo] ,T4=[No1] ,T5=[No2] ,T6=[BLNo],T7/T8[Status],T9[feeder],T10[Size] ,T11[TypeCode] ,T12[Cosignee],VMST_Cosignee.codedesc,T13[DischDate] ,T14[CosigPickDate],T15[ReturnInDepotDate] ,T16[Remark],T17[Doc],
//T18[Shipper],VMST_Shipper.codedesc,T19[Status2],T20[GetOut] ,T21[GetInPort],T22[LoadOnFeeder] ,T23[vsl],T24[EtdBtm],T25[EtaBtm],T26[SealNo],T29[BLNO2],T28[DM],T29[ExpBL],T30[ExpCode] ,T31[ExpDept] ,T32[ExpTrade] ,T33[ImpBL] ,T34[ImpCode],T35[ImpDept],T36[ImpTrade],T37[Service],T38[POD]
            if(Gen.gettable(request.getParameter("add")).equalsIgnoreCase("true")){//Umum
                java.util.Vector exist=sgen.getDataQuery(conn,"MOVEMENTMAXSEQ",new String[]{Gen.gettable(request.getParameter("T1")),Gen.gettable(request.getParameter("T2"))});
                String seq="1";
                if(exist.size()>0) seq=""+(gen.getInt(exist.get(0))+1);
                y1=Gen.gettable(request.getParameter("T2"));//trxdate
                y2=seq;
                y3=Gen.gettable(request.getParameter("T1")).toUpperCase();//container
                String sts=Gen.gettable(request.getParameter("T8"));
                if(sts.length()==0)sts=Gen.gettable(request.getParameter("T7"));
                String sts2=Gen.gettable(request.getParameter("T19"));
                if(sts2.length()==0)sts2=Gen.gettable(request.getParameter("T19N"));
                if(y3.length()!=11){
                    msg="Invalid Container No (4 digits Alphabet and 7 digits Numeric)";
                }
             //   System.out.println("B");
                if(msg.length()==0){
                  String str=y3.substring(0,4);
                  char[] ch = str.toCharArray();
                  for (int i = 0; i < str.length(); i++) {
                      int cch=(int)ch[i];
                      if (cch>=65 && cch<=90) {                        
                      }else{
                          msg="Invalid Container No (4 digits Alphabet and 7 digits Numeric)";
                          break;
                      }
                  }
                  if(msg.length()==0){
                    str=y3.substring(4);
                    ch = str.toCharArray();
                    for (int i = 0; i < str.length(); i++) {
                        int cch=(int)ch[i];
                        if (cch>=48 && cch<=57) {                        
                        }else{
                            msg="Invalid Container No (4 digits Alphabet and 7 digits Numeric)";
                            break;
                        }
                    }
                  }
                 // System.out.println("A");
                  if(msg.length()==0){
                      String BL=""; if(gen.gettable(request.getParameter("T29")).length()>0) BL=gen.gettable(request.getParameter("T29")).substring(0,1);
                      msg=sgen.update(conn,"MOVEMENTADD",new String[]{gen.gettable(request.getParameter("T3")),gen.gettable(request.getParameter("T4")),gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T6")),sts,gen.gettable(request.getParameter("T9")),gen.gettable(request.getParameter("T10")),gen.gettable(request.getParameter("T11")),gen.gettable(request.getParameter("T12")),gen.gettable(request.getParameter("T13")),gen.gettable(request.getParameter("T14")),gen.gettable(request.getParameter("T15")),gen.gettable(request.getParameter("T16")),gen.gettable(request.getParameter("T17")),gen.gettable(request.getParameter("T18")),sts2,gen.gettable(request.getParameter("T20")),gen.gettable(request.getParameter("T21")),gen.gettable(request.getParameter("T22")),gen.gettable(request.getParameter("T23")),gen.gettable(request.getParameter("T24")),gen.gettable(request.getParameter("T25")),gen.gettable(request.getParameter("T26")),gen.gettable(request.getParameter("T29")),gen.gettable(request.getParameter("T28")),BL,gen.gettable(request.getParameter("T30")),gen.gettable(request.getParameter("T31")),gen.gettable(request.getParameter("T32")),gen.gettable(request.getParameter("T33")),gen.gettable(request.getParameter("T34")),gen.gettable(request.getParameter("T35")),gen.gettable(request.getParameter("T36")),gen.gettable(request.getParameter("T37")),gen.gettable(request.getParameter("T38")),Gen.gettable(request.getParameter("T39")),Gen.gettable(request.getParameter("T40")),Gen.gettable(request.getParameter("T41")),Gen.gettable(request.getParameter("T44")),y1,y2,y3});
                      msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"MOVEMENTADD",y1+"|"+y2+"|"+y3+"|"});
                  }
                }
               // System.out.println("C");
                if(msg.length()>0){
//T2=trxdate,//T3=[tpContainer],T1=[ContNo] ,T4=[No1] ,T5=[No2] ,T6=[BLNo],T7/T8[Status],T9[feeder],T10[Size] ,T11[TypeCode] ,T12[Cosignee],VMST_Cosignee.codedesc,T13[DischDate] ,T14[CosigPickDate],T15[ReturnInDepotDate] ,T16[Remark],T17[Doc],
//T18[Shipper],VMST_Shipper.codedesc,T19[Status2],T20[GetOut] ,T21[GetInPort],T22[LoadOnFeeder] ,T23[vsl],T24[EtdBtm],T25[EtaBtm],T26[SealNo],T27[BLNO2],T28[DM],T29[ExpBL],T30[ExpCode] ,T31[ExpDept] ,T32[ExpTrade] ,T33[ImpBL] ,T34[ImpCode],T35[ImpDept],T36[ImpTrade],T37[Service],T38[POD]
                    databef.addElement(gen.gettable(request.getParameter("T3")));
                    databef.addElement(gen.gettable(request.getParameter("T1")));
                    databef.addElement("");
                    databef.addElement("");
                    databef.addElement(gen.gettable(request.getParameter("T6")));
                    databef.addElement(gen.gettable(request.getParameter("T7")));
                    databef.addElement(gen.gettable(request.getParameter("T9")));
                    databef.addElement(gen.gettable(request.getParameter("T10")));
                    databef.addElement(gen.gettable(request.getParameter("T11")));
                    databef.addElement(gen.gettable(request.getParameter("T12")));
                    databef.addElement(gen.gettable(request.getParameter("ST12")));
                    databef.addElement(gen.gettable(request.getParameter("T13")));
                    databef.addElement(gen.gettable(request.getParameter("T14")));
                    databef.addElement(gen.gettable(request.getParameter("T15")));
                    databef.addElement(gen.gettable(request.getParameter("T16")));
                    databef.addElement(gen.gettable(request.getParameter("T17")));
                    databef.addElement(gen.gettable(request.getParameter("T18")));
                    databef.addElement(gen.gettable(request.getParameter("ST18")));
                    databef.addElement(gen.gettable(request.getParameter("T19")));
                    databef.addElement(gen.gettable(request.getParameter("T20")));
                    databef.addElement(gen.gettable(request.getParameter("T21")));
                    databef.addElement(gen.gettable(request.getParameter("T22")));
                    databef.addElement(gen.gettable(request.getParameter("T23")));
                    databef.addElement(gen.gettable(request.getParameter("T24")));
                    databef.addElement(gen.gettable(request.getParameter("T25")));
                    databef.addElement(gen.gettable(request.getParameter("T26")));
                    databef.addElement(gen.gettable(request.getParameter("T29")));
                    databef.addElement(gen.gettable(request.getParameter("T28")));
                    databef.addElement("");
                    databef.addElement(gen.gettable(request.getParameter("T30")));
                    databef.addElement(gen.gettable(request.getParameter("T31")));
                    databef.addElement(gen.gettable(request.getParameter("T32")));
                    databef.addElement(gen.gettable(request.getParameter("T33")));
                    databef.addElement(gen.gettable(request.getParameter("T34")));
                    databef.addElement(gen.gettable(request.getParameter("T35")));
                    databef.addElement(gen.gettable(request.getParameter("T36")));
                    databef.addElement(gen.gettable(request.getParameter("T37")));
                    databef.addElement(gen.gettable(request.getParameter("T38")));
                    databef.addElement(gen.gettable(request.getParameter("T39")));
                    databef.addElement(gen.gettable(request.getParameter("T40")));
                    databef.addElement(gen.gettable(request.getParameter("T41")));
                    databef.addElement(gen.gettable(request.getParameter("T43")));
                    databef.addElement(gen.gettable(request.getParameter("T44")));
                }                
            }else{//update
                String seq=gen.gettable(request.getParameter("S2"));
                String sts=Gen.gettable(request.getParameter("T8"));
                if(sts.length()==0)sts=Gen.gettable(request.getParameter("T7"));
                String sts2=Gen.gettable(request.getParameter("T19"));
                if(sts2.length()==0)sts2=Gen.gettable(request.getParameter("T19N"));
                String BL=""; if(gen.gettable(request.getParameter("T29")).length()>0) BL=gen.gettable(request.getParameter("T29")).substring(0,1);
                
                msg=sgen.update(conn,"MOVEMENTUPDATE",new String[]{gen.gettable(request.getParameter("T3")),gen.gettable(request.getParameter("T4")),gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T6")),sts,gen.gettable(request.getParameter("T9")),gen.gettable(request.getParameter("T10")),gen.gettable(request.getParameter("T11")),gen.gettable(request.getParameter("T12")),gen.gettable(request.getParameter("T13")),gen.gettable(request.getParameter("T14")),gen.gettable(request.getParameter("T15")),gen.gettable(request.getParameter("T16")),gen.gettable(request.getParameter("T17")),gen.gettable(request.getParameter("T18")),sts2,gen.gettable(request.getParameter("T20")),gen.gettable(request.getParameter("T21")),gen.gettable(request.getParameter("T22")),gen.gettable(request.getParameter("T23")),gen.gettable(request.getParameter("T24")),gen.gettable(request.getParameter("T25")),gen.gettable(request.getParameter("T26")),gen.gettable(request.getParameter("T29")),gen.gettable(request.getParameter("T28")),BL,gen.gettable(request.getParameter("T30")),gen.gettable(request.getParameter("T31")),gen.gettable(request.getParameter("T32")),gen.gettable(request.getParameter("T33")),gen.gettable(request.getParameter("T34")),gen.gettable(request.getParameter("T35")),gen.gettable(request.getParameter("T36")),gen.gettable(request.getParameter("T37")),gen.gettable(request.getParameter("T38")),Gen.gettable(request.getParameter("T39")),Gen.gettable(request.getParameter("T40")),Gen.gettable(request.getParameter("T41")),Gen.gettable(request.getParameter("T44")),y1,y2,y3});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"MOVEMENTUPDATE",y1+"|"+y2+"|"+y3+"|"});
            }
            if(msg.length()==0){
            
                if(gen.gettable(request.getParameter("T22")).length()>0) {//load on feeder
                    msg=sgen.update(conn,"EXPSTS4",new String[]{gen.gettable(request.getParameter("T22")),y3,y1});
                    msg=sgen.update(conn,"EXPSTS5",new String[]{y3,y1});
                }
                if(gen.gettable(request.getParameter("T6")).length()>0){//no bl isi
                    msg=sgen.update(conn,"IMPBL",new String[]{gen.gettable(request.getParameter("T6")).substring(0,1), y3,y1});//update Impl BL
                }                
            }
          if(msg.length()>0){
              msg="(Save Failed!!"+msg+")";
          }else{
              msg="(Saved Successfully)";
          }     
        }
        String[] cond=new String[]{y1,y2,y3};
//        System.out.println(y1+","+y2+","+y3);
        java.util.Vector vk=sgen.getDataQuery(conn,"MOVEMENTDETAIL",cond);
        String add="false";
        String trx=gen.gettable(request.getParameter("T2"));
        //[tpContainer],[ContNo] ,[No1] ,[No2] ,[BLNo],[Status],[feeder],[Size] ,[TypeCode] ,[Cosignee],VMST_Cosignee.codedesc,[DischDate] ,[CosigPickDate],[ReturnInDepotDate] ,[Remark],[Doc],[Shipper],VMST_Shipper.codedesc,[Status2],[GetOut] ,[GetInPort],[LoadOnFeeder] ,[vsl],[EtdBtm],[EtaBtm],[SealNo],[BLNO2],[DM],[ExpBL],[ExpCode] ,[ExpDept] ,[ExpTrade] ,[ImpBL] ,[ImpCode],[ImpDept],[ImpTrade],[Service],[POD] 
        if(vk.size()==0){
            if(databef.size()==0){
              for(int m=0;m<43;m++)vk.addElement("");
              y1=gen.getToday("dd-MM-yyyy");
              vk.setElementAt(y1,11);
            }else{
              vk=databef;
            }
            add="true";
        }
        java.util.Vector vtrx=gen.getElement('-',y1+"-");
        String yr="";
        if(vtrx.size()>1) yr=gen.gettable(vtrx.get(2));
        int endwk=53;//gen.getWeek("30-12-"+yr,"dd-MM-yyyy");
        //System.out.println("end week="+endwk+",yr="+yr);
        java.util.Vector status1=sgen.getDataQuery(conn,"STATUS1",new String[0]);
        java.util.Vector status2=sgen.getDataQuery(conn,"STATUS2",new String[0]);
        java.util.Vector typecode=new java.util.Vector();//sgen.getDataQuery(conn,"TYPECODE",new String[0]);
        typecode.addElement("FR");
        typecode.addElement("GP");        
        typecode.addElement("HQ");
        typecode.addElement("OT");
        
        java.util.Vector code=sgen.getDataQuery(conn,"MOVECODE",new String[0]);
        java.util.Vector dept=sgen.getDataQuery(conn,"DEPT",new String[0]);
        java.util.Vector trade=sgen.getDataQuery(conn,"TRADE",new String[0]);
        java.util.Vector stat=sgen.getDataQuery(conn,"MOVEMENTSTATUS1",new String[]{gen.gettable(vk.get(5)),yr});
        java.util.Vector stat2=sgen.getDataQuery(conn,"MOVEMENTSTATUS2",new String[]{gen.gettable(vk.get(18)),yr});
        String[] siz=new String[]{"20B","40B","20W","40W"};
         connMgr.freeConnection("db2", conn);
          connMgr.release();
          
        String view=Gen.gettable(request.getParameter("view"));
        if (Gen.gettable(request.getParameter("canedit")).equalsIgnoreCase("false")){
            view="disabled";
        }
        java.util.Vector imp=new java.util.Vector();
        java.util.Vector exp=new java.util.Vector();
        for(int ii=0;ii<siz.length;ii++){
            String sz=siz[ii].substring(0,2);
            String mt=siz[ii].substring(2,siz[ii].length());
            
            imp.addElement(sz);
            imp.addElement(mt);
            exp.addElement(sz);
            exp.addElement(mt);
            for(int ij=1;ij<=53;ij++){
                    String tc="";
                    for(int i=0;i<stat.size();i+=4){
                        String s=gen.gettable(stat.get(i+2)).trim()+""+gen.gettable(stat.get(i+1)).trim();
                        if(siz[ii].equalsIgnoreCase(s) && gen.getInt(stat.get(i+3))==ij){
                            tc=gen.gettable(stat.get(i));
                        }
                    }
                    imp.addElement(tc);
                    tc="";
                    for(int i=0;i<stat2.size();i+=4){
                        String s=gen.gettable(stat2.get(i+2)).trim()+""+gen.gettable(stat2.get(i+1)).trim();
                        if(siz[ii].equalsIgnoreCase(s) && gen.getInt(stat2.get(i+3))==ij){
                            tc=gen.gettable(stat2.get(i));
                        }
                    }
                    exp.addElement(tc);
            }
        }
%>

	<body class="no-skin" <%if(gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false") && Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){%>onload="window.close()"<%}%>>
    <%if(view.length()==0 && !gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false")){%>
        <jsp:include page="menu.jsp" flush ="true"/>
    <%}%>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1>
								Movement <%=msg%>
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
																Movement Information
															</a>
														</li>
                                                        <%if(Gen.gettable(vk.get(1)).trim().length()!=0 && !gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false")){%>
														<li>
															<a data-toggle="tab" href="#edit-status1">
																<i class="blue ace-icon fa fa-file-o bigger-125"></i>
															     <%=gen.gettable(vk.get(5))%>
															</a>
														</li>
                                                        <%if(Gen.gettable(vk.get(18)).trim().length()!=0 && !gen.gettable(request.getParameter("menu")).equalsIgnoreCase("false")){%>
														<li>
															<a data-toggle="tab" href="#edit-status2">
																<i class="blue ace-icon fa fa-file-o bigger-125"></i>
															     <%=gen.gettable(vk.get(18))%>
															</a>
														</li>
                                                        <%}%>
                                                        <%}%>
													</ul>

													<div class="tab-content profile-edit-tab-content">                                                    
														<div id="edit-basic" class="tab-pane in active">
            											<form class="form-horizontal" name="BGA" method="POST" action="movementdetail.jsp?tp=<%=Gen.gettable(request.getParameter("tp"))%>&canedit=<%=Gen.gettable(request.getParameter("canedit"))%>&menu=<%=Gen.gettable(request.getParameter("menu"))%>" >
															<h4 class="header blue bolder smaller">Movement Information</h4>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">*Container No : </label>																
																<label class="control-label">
                                                                <%if(Gen.gettable(vk.get(1)).trim().length()==0){%>
																	<input type="text" id="T1" maxlength="11" size="11" name="T1"  placeholder="Container No" value="<%=Gen.gettable(vk.get(1)).trim()%>" <%=view%>/>
                                                                    &nbsp;&nbsp;Date:<input class="input-medium date-picker" name="T2"  id="T2" type="text" data-date-format="dd-mm-yyyy" value="<%=y1%>" placeholder="dd-mm-yyyy" <%=view%>/><i class="ace-icon fa fa-calendar"></i>
                                                                <%}else{%>
																	<input type="text" id="T1" maxlength="11" size="11" name="T1"  placeholder="Container No" value="<%=Gen.gettable(vk.get(1)).trim()%>" disabled/>
                                                                    &nbsp;&nbsp;Date:<input class="input-medium date-picker" name="T2"  id="T2" type="text" data-date-format="dd-mm-yyyy" value="<%=y1%>" placeholder="dd-mm-yyyy" disabled/>
                                                                <%}%>
                                                                    &nbsp;&nbsp;Depo:<select name="T3" <%=view%> <%=view%>>
                                                                    <option></option>
                                                                	<option value="B" <%if(Gen.gettable(vk.get(0)).trim().equalsIgnoreCase("B")) out.print("selected");%>>B</option>
                                                                	<option value="W" <%if(Gen.gettable(vk.get(0)).trim().equalsIgnoreCase("W")) out.print("selected");%>>W</option>
                                                                	<option value="S" <%if(Gen.gettable(vk.get(0)).trim().equalsIgnoreCase("S")) out.print("selected");%>>S</option>
                                                                    </select>                                                                    
                                                                </B></label>
															</div>
															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">BL No : </label>
																<label class="control-label">
																<input type="text" id="T6" size="15" maxlength="15" name="T6"  placeholder="BL. No." value="<%=Gen.gettable(vk.get(4)).trim()%>" <%=view%>/>                                                                
      															&nbsp;*Status:<select name="T7" <%=view%>>
                                                                    <option></option>
                                                                    <%for(int m=0;m<status1.size();m+=1){%>
                                                                	<option value="<%=gen.gettable(status1.get(m))%>" <%if(Gen.gettable(vk.get(5)).trim().equalsIgnoreCase(gen.gettable(status1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(status1.get(m)).trim()%></option>
                                                                    <%}%>
                                                                    </select>
                                                                &nbsp;Create New:<input type="text" id="T8" size="10" maxlength="10" name="T8"  placeholder="New Status" value="<%=Gen.gettable(request.getParameter("T8")).trim()%>" <%=view%>/>
                                                                &nbsp;Free Time:<input type="text" id="T39" size="2" maxlength="3" name="T39"  placeholder="" value="<%=Gen.gettable(vk.get(38)).trim()%>" <%=view%>/>
                                                                </label>
															</div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">Code : </label>
																<label class="control-label">
                                                                &nbsp;<b><%=Gen.gettable(vk.get(33)).trim()%></b>
    															&nbsp;&nbsp;Dept:&nbsp;<b><%=Gen.gettable(vk.get(34)).trim()%></b>
    															&nbsp;&nbsp;Trade:&nbsp;<b><%=Gen.gettable(vk.get(35)).trim()%></b>
                                                                </label>                                                                
															</div>
                                                            <h4 class="header blue bolder smaller">Cosignee Information</h4>
															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">Feeder Voyage : </label>
																<label class="control-label">
																<input type="text" id="T9" size="15" maxlength="15" name="T9"  placeholder="Feeder Voyage" value="<%=Gen.gettable(vk.get(6)).trim()%>" <%=view%>/>
      															&nbsp;&nbsp;*Size :<select name="T10" <%=view%>>
                                                                	<option value="40" <%if(Gen.gettable(vk.get(7)).trim().equalsIgnoreCase("40")) out.print("selected");%>>40</option>
                                                                	<option value="20" <%if(Gen.gettable(vk.get(7)).trim().equalsIgnoreCase("20")) out.print("selected");%>>20</option>
                                                                    </select>
      															&nbsp;&nbsp;*Type Code:<select name="T11" <%=view%>>
                                                                    <option></option>
                                                                    <%for(int m=0;m<typecode.size();m+=1){%>
                                                                	<option value="<%=gen.gettable(typecode.get(m))%>" <%if(Gen.gettable(vk.get(8)).trim().equalsIgnoreCase(gen.gettable(typecode.get(m)).trim())) out.print("selected");%>><%=gen.gettable(typecode.get(m)).trim()%></option>
                                                                    <%}%>
                                                                </select>
                                                                   </label>
															</div>
															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">*Cosignee : </label>
                                                                <label class="control-label">
                                              		              <input type="text" name="T12"  size="10" value="<%=Gen.gettable(vk.get(9))%>" disabled>
                                              		              <input type="text" name="ST12" size="40" maxlength="60" tabindex="5"  value="<%=Gen.gettable(vk.get(10)).trim()%>" disabled>
                                                                  <%if(view.length()==0){%>
                                   				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('COSIGNEE','T12','ST12','','')">
                                                                  <%}%>
                                                                &nbsp;POL:<input type="text" id="T41" size="5" maxlength="6" name="T41"  placeholder="POL" value="<%=Gen.gettable(vk.get(40)).trim()%>" <%=view%>/>
                                                                </label>
															</div>
															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">Discharge Date : </label>
                                                                <label class="control-label">
                                                                    <input class="input-medium date-picker" name="T13"  id="T13" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(11)).trim()%>" placeholder="dd-mm-yyyy" <%=view%>/><i class="ace-icon fa fa-calendar"></i>
                                                                    &nbsp;&nbsp;Pickup Date:<input class="input-medium date-picker" name="T14"  id="T14" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(12)).trim()%>" placeholder="dd-mm-yyyy" <%=view%> /><i class="ace-icon fa fa-calendar"></i>
                                                                    &nbsp;&nbsp;Return In Deport:<input class="input-medium date-picker" name="T15"  id="T15" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(13)).trim()%>" placeholder="dd-mm-yyyy" <%=view%>/><i class="ace-icon fa fa-calendar"></i>
                                                                    &nbsp;&nbsp;DM:<input type="hidden" id="T43" name="T43"  value="<%=Gen.gettable(vk.get(41)).trim()%>" <%=view%>/><%=gen.gettable(vk.get(41)).trim()%>                                                                
                                                                </label>
                                                             </div>                                                              
															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">Remark : </label>
                                                                <label class="control-label">
                                                                <input type="text" id="T16" size="30" maxlength="60" name="T16"  placeholder="Remark" value="<%=Gen.gettable(vk.get(14)).trim()%>" <%=view%>/>
                                                                &nbsp;&nbsp;Document:<input type="text" id="T17" size="30" maxlength="60" name="T17"  placeholder="Document" value="<%=Gen.gettable(vk.get(15)).trim()%>" <%=view%>/>
                                                                &nbsp;&nbsp;Cond:<select name="T44" <%=view%> >
                                                                    <option></option>
                                                                	<option value="A" <%if(Gen.gettable(vk.get(42)).trim().equalsIgnoreCase("A")) out.print("selected");%>>Food type</option>
                                                                	<option value="B" <%if(Gen.gettable(vk.get(42)).trim().equalsIgnoreCase("B")) out.print("selected");%>>Standar</option>
                                                                	<option value="C" <%if(Gen.gettable(vk.get(42)).trim().equalsIgnoreCase("C")) out.print("selected");%>>Old Container</option>
                                                                	<option value="R" <%if(Gen.gettable(vk.get(42)).trim().equalsIgnoreCase("R")) out.print("selected");%>>Repair/Reject</option>
                                                                    </select>                                                                    

                                                                </label>
															</div>
                                                            <h4 class="header blue bolder smaller">Shipping Information</h4>
  															<div class="space-4"></div>
  															<div class="form-group">
  																<label class="col-sm-3 control-label no-padding-right ">Shipper : </label>
                                                                <label class="control-label">
                                              		              <input type="hidden" name="T18" value="<%=Gen.gettable(vk.get(16)).trim()%>">
                                              		              <input type="text" name="ST18" size="40" maxlength="60" tabindex="10"  value="<%=Gen.gettable(vk.get(17)).trim()%>" disabled>
                                                                  <%if(view.length()==0){%>
                                       				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('SHIPPER','T18','ST18','','')">
                                                                  <%}%>
                                                                </label>
  															</div>                  
  															<div class="form-group">
  																<label class="col-sm-3 control-label no-padding-right ">Status 2 :</label>
                                                                <label class="control-label">
      															<select name="T19" <%=view%>>
                                                                    <option></option>
                                                                    <%for(int m=0;m<status2.size();m+=1){%>
                                                                	<option value="<%=gen.gettable(status2.get(m))%>" <%if(Gen.gettable(vk.get(18)).trim().equalsIgnoreCase(gen.gettable(status2.get(m)).trim())) out.print("selected");%>><%=gen.gettable(status2.get(m)).trim()%></option>
                                                                    <%}%>
                                                                    </select>
                                                                &nbsp;Create New:<input type="text" id="T19N" size="10" maxlength="10" name="T19N"  placeholder="New Status" value="<%=Gen.gettable(request.getParameter("T19N")).trim()%>" <%=view%>/>
                                                                &nbsp;Free Time:<input type="text" id="T40" size="2" maxlength="3" name="T40"  placeholder="" value="<%=Gen.gettable(vk.get(39)).trim()%>" <%=view%>/>                                                                
                                                                </label>
  															</div>                  
  															<div class="form-group">
  																<label class="col-sm-3 control-label no-padding-right ">Get Out Date : </label>
                                                                <label class="control-label">
                                                                    <input class="input-medium date-picker" name="T20"  id="T20" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(19)).trim()%>" placeholder="dd-mm-yyyy" <%=view%>/><i class="ace-icon fa fa-calendar"></i>
                                                                    &nbsp;&nbsp;Get In Port :<input class="input-medium date-picker" name="T21"  id="T21" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(20)).trim()%>" placeholder="dd-mm-yyyy" <%=view%>/><i class="ace-icon fa fa-calendar"></i>
                                                                    &nbsp;&nbsp;Load On Feeder:<input class="input-medium date-picker" name="T22"  id="T22" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(21)).trim()%>" placeholder="dd-mm-yyyy" <%=view%>/><i class="ace-icon fa fa-calendar"></i>                                                                
                                                                </label>
  															</div>                  
  															<div class="space-4"></div>
  															<div class="form-group">
  																<label class="col-sm-3 control-label no-padding-right ">VSL : </label>
                                                                    <input type="text" id="T23" name="T23" maxlength="15" size="13" value="<%=gen.gettable(vk.get(22)).trim()%>" <%=view%>/>
                                                                    &nbsp;&nbsp;ETD Btm:<input class="input-medium date-picker" name="T24"  id="T24" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(23)).trim()%>" placeholder="dd-mm-yyyy" <%=view%>/><i class="ace-icon fa fa-calendar"></i>
                                                                    &nbsp;&nbsp;ETA Sg:<input class="input-medium date-picker" name="T25"  id="T25" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(vk.get(24)).trim()%>" placeholder="dd-mm-yyyy" <%=view%>/><i class="ace-icon fa fa-calendar"></i>
                                                                    &nbsp;&nbsp;DM:<input type="hidden" id="T28" name="T28" value="<%=gen.gettable(vk.get(27)).trim()%>" <%=view%>/><%=gen.gettable(vk.get(27)).trim()%>                                                                
                                                                </label>
  															</div>                  
  															<div class="space-4"></div>
  															<div class="form-group">
  																<label class="col-sm-3 control-label no-padding-right ">Seal No. : </label>
                                                                    <label class="control-label"><input type="text" id="T26" name="T26" maxlength="20" size="10" value="<%=gen.gettable(vk.get(25)).trim()%>" <%=view%>/>
                                                                    &nbsp;&nbsp;BL No:<input type="text" id="T29" name="T29" maxlength="15" size="10" value="<%=gen.gettable(vk.get(26)).trim()%>" <%=view%>/>                                                                    
                                                                    &nbsp;&nbsp;Code:&nbsp;<b><%=Gen.gettable(vk.get(29)).trim()%></b>
        															&nbsp;&nbsp;Dept:&nbsp;<b><%=Gen.gettable(vk.get(30)).trim()%></b>
        															&nbsp;&nbsp;Trade:&nbsp;<b><%=Gen.gettable(vk.get(31)).trim()%></b>
                                                                </label>
  															</div>                  
                                                            <h4 class="header blue bolder smaller">Other Information</h4>
															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">Service: </label>
                                                                <label class="control-label">
																<input type="text" id="T37" size="4" maxlength="5" name="T37"  placeholder="Service" value="<%=Gen.gettable(vk.get(36)).trim()%>" <%=view%>/>
                                                                &nbsp;&nbsp;POD:<input type="text" id="T38" size="5" maxlength="6" name="T38"  placeholder="POD" value="<%=Gen.gettable(vk.get(37)).trim()%>" <%=view%>/>
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
                                                                  <input type="hidden" name="S1" value="<%=y1%>">
                                                                  <input type="hidden" name="S2" value="<%=y2%>">
                                                                  <input type="hidden" name="S3" value="<%=y3%>">
                                                                  <input type="hidden" name="x" value="1">
                  											</form>
														</div>
                                                        
														<div id="edit-status1" class="tab-pane">
                                                            <table id="simple-table" class="table  table-bordered table-hover">
                												<thead>
                													<tr>
                                                                        <th>WEEK</th>
                                                                        <%for(int mx=1;mx<=27;mx++){%>
                                                                        <th><%=(""+mx)%></th>
                                                                        <%}%>
                													</tr>
                													<tr>
                                                                        <th>SIZE - TP</th>
                                                                        <%for(int mx=28;mx<=53;mx++){%>
                                                                        <th><%=(""+mx)%></th>
                                                                        <%}%>
                                                                        <th></th>
                													</tr>
                												</thead>                
                												<tbody>
                                                                    <%for(int i=0;i<imp.size();i+=55){%>
                                                						<tr>
                                                                            <td nowrap><%=gen.gettable(imp.get(i))%>-<%=gen.gettable(imp.get(i+1))%></td>
                                                                        <%for(int mx=1;mx<=27;mx++){%>
                                                                              <%if(view.length()==0){%>
                                                                              <td ><a href="javascript:jump1('<%=gen.gettable(vk.get(5))%>','<%=gen.gettable(imp.get(i+1))%>','<%=gen.gettable(imp.get(i))%>','<%=(""+mx)%>')"><%=gen.gettable(imp.get(mx+i+1))%></a></td>
                                                                              <%}else{%>                                                                                
                                                                              <td nowrap><%=gen.gettable(imp.get(i+mx+1))%></td>
                                                                              <%}%>
                                                                        <%}%>                                                                                
                                                   					    </tr>
                                                						<tr>
                                                                            <td nowrap></td>
                                                                        <%for(int mx=28;mx<=53;mx++){%>
                                                                              <%if(view.length()==0){%>
                                                                              <td ><a href="javascript:jump1('<%=gen.gettable(vk.get(5))%>','<%=gen.gettable(imp.get(i+1))%>','<%=gen.gettable(imp.get(i))%>','<%=(""+mx)%>')"><%=gen.gettable(imp.get(mx+i+1))%></a></td>
                                                                              <%}else{%>                                                                                
                                                                              <td nowrap><%=gen.gettable(imp.get(i+mx+1))%></td>
                                                                              <%}%>
                                                                        <%}%>              
                                                                                                                                          
                                                   					    </tr>
                                                                    <%}%>
                												</tbody>
                											</table>
														</div>
														<div id="edit-status2" class="tab-pane">
                                                            <table id="simple-table" class="table  table-bordered table-hover">
                												<thead>
                													<tr>
                                                                        <th>WEEK</th>
                                                                        <%for(int mx=1;mx<=27;mx++){%>
                                                                        <th><%=(""+mx)%></th>
                                                                        <%}%>
                													</tr>
                													<tr>
                                                                        <th>SIZE - TP</th>
                                                                        <%for(int mx=28;mx<=53;mx++){%>
                                                                        <th><%=(""+mx)%></th>
                                                                        <%}%>
                                                                        <th></th>
                													</tr>
                												</thead>                
                												<tbody>
                                                                    <%for(int i=0;i<exp.size();i+=55){%>
                                                						<tr>
                                                                            <td nowrap><%=gen.gettable(exp.get(i))%>-<%=gen.gettable(exp.get(i+1))%></td>
                                                                        <%for(int mx=1;mx<=27;mx++){%>
                                                                              <%if(view.length()==0){%>
                                                                              <td ><a href="javascript:jump('<%=gen.gettable(vk.get(18))%>','<%=gen.gettable(exp.get(i+1))%>','<%=gen.gettable(exp.get(i))%>','<%=(""+mx)%>')"><%=gen.gettable(exp.get(mx+i+1))%></a></td>
                                                                              <%}else{%>                                                                                
                                                                              <td nowrap><%=gen.gettable(exp.get(i+mx+1))%></td>
                                                                              <%}%>
                                                                        <%}%>                                                                                
                                                   					    </tr>
                                                						<tr>
                                                                            <td nowrap><%=gen.gettable(exp.get(i))%>-<%=gen.gettable(exp.get(i+1))%></td>
                                                                        <%for(int mx=28;mx<=53;mx++){%>
                                                                              <%if(view.length()==0){%>
                                                                              <td ><a href="javascript:jump1('<%=gen.gettable(vk.get(18))%>','<%=gen.gettable(exp.get(i+1))%>','<%=gen.gettable(exp.get(i))%>','<%=(""+mx)%>')"><%=gen.gettable(exp.get(mx+i+1))%></a></td>
                                                                              <%}else{%>                                                                                
                                                                              <td nowrap><%=gen.gettable(exp.get(i+mx+1))%></td>
                                                                              <%}%>
                                                                        <%}%>                                                                                
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
    
	function jump1(P1,P2,P3,P4){
		url="movementc.jsp?tp=CONTAINER1&S5=<%=yr%>&S1="+P1+"&S2="+P2+"&S3="+P3+"&S4="+P4;
		window.open(url,"", "height=600,width=1200,toolbar=no,scrollbars=yes,menubar=no");
	}
	function jump(P1,P2,P3,P4){
		url="movementc.jsp?tp=CONTAINER2&S5=<%=yr%>&S1="+P1+"&S2="+P2+"&S3="+P3+"&S4="+P4;
		window.open(url,"", "height=600,width=1200,toolbar=no,scrollbars=yes,menubar=no");
	}
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
      //*T1=[JobNo],[Seq],*T2=[TrxDate],*T3=[Acct],T5=[DebetKredit],T8=[RefNo1],*T7=[Code],*T6=[TypeJob],*T4=[JobStatus],[USD],[SGD],T9 AMT[IDR] ,T10[Rate],T11 CURR,[Comment],ST3=[Desc],T12[RefNo2],
//                                                            T13=16 [Vendor],T14=17 [BillTo],T15=18 [Customer],T16=[MYOBNO],T17=[MYOBAMT],T18=[MYOBSTATUS]

            function SetTime(trans,format){
               var y=m=d="";
               y=trans.charAt(6)+trans.charAt(7)+trans.charAt(8)+trans.charAt(9);
               if(format=="M"){
                  m=(trans.charAt(0)+trans.charAt(1))-1;
                  d=trans.charAt(3)+trans.charAt(4);
               }
               else {
                  d=trans.charAt(0)+trans.charAt(1);
                  m=(trans.charAt(3)+trans.charAt(4))-1;
               }
               var transdate = new Date(y,m,d);
               
               return transdate;
            }
            function  setsave(Parm){
                if(Parm=="1"){
                  var canin=true;
                  if(document.BGA.T1.value==""){
                      alert("Container No must be Filled!");
                      canin=false;
                  }else if(document.BGA.T2.value==""){
                      alert("Transaction Date must be filled!");
                      canin=false;
                  }else if(document.BGA.T3.value==""){
                      alert("Depo must be filled");
                      canin=false;
                  }else if(document.BGA.T7.value=="" && document.BGA.T8.value==""){
                      alert("Status must be filled");
                      canin=false;
                  }else if(document.BGA.T11.value==""){
                      alert("Type Code must be filled");
                      canin=false;
                  }else if(document.BGA.T12.value==""){
                      alert("Cosignee Type must be filled");
                      canin=false;
                  }
                  if(document.BGA.T13.value!="" && document.BGA.T14.value!=""){
                       var disc = SetTime(document.BGA.T13.value,"D");
                       var pick = SetTime(document.BGA.T14.value,"D");
                       if(disc>pick){
                            alert("Invalid Pickup Date. Valid Input (Pickup Date >= Discharge Date)");
                            canin=false;
                       }
                  }
                  if(document.BGA.T14.value!="" && document.BGA.T15.value!=""){
                       var pick = SetTime(document.BGA.T14.value,"D");
                       var ret = SetTime(document.BGA.T15.value,"D");
                       if(pick>ret){
                            alert("Invalid Return In Depot Date.Valid (Input Return In Depot Date >= Pickup Date)");
                            canin=false;
                       }
                  }
                  if(document.BGA.T20.value!="" && document.BGA.T21.value!=""){
                       var a = SetTime(document.BGA.T20.value,"D");
                       var b = SetTime(document.BGA.T21.value,"D");
                       if(a>b){
                            alert("Invalid Get In Port Date.Valid Input (Get In Port Date >= Get Out Date)");
                            canin=false;
                       }
                  }
                  if(document.BGA.T21.value!="" && document.BGA.T22.value!=""){
                       var a = SetTime(document.BGA.T21.value,"D");
                       var b = SetTime(document.BGA.T22.value,"D");
                       if(a>b){
                            alert("Invalid Load of Feeder Date.Valid Input (Load of Feeder Date >= Get In Port Date)");                            
                            canin=false;
                       }
                  }
                  if(canin){
                     document.BGA.T1.disabled=false;
                     document.BGA.T2.disabled=false;
                     document.BGA.T12.disabled=false;
                     document.BGA.T18.disabled=false;
                     document.BGA.ST12.disabled=false;
                     document.BGA.ST18.disabled=false;
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
