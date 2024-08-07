<%@ page import="jxl.*"%>
<%@ page import="java.io.*"%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
<title>3R Corporate</title>
<link href="image/3R.png" rel="icon">
		<meta name="description" content="Static &amp; Dynamic Tables" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="assets/css/bootstrap.min.css" />
		<link rel="stylesheet" href="assets/font-awesome/4.5.0/css/font-awesome.min.css" />

		<!-- page specific plugin styles -->

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
        com.ysoft.General gen = new com.ysoft.General();
        com.ysoft.General Gen = new com.ysoft.General();  
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral(); 
        String tp=gen.gettable(request.getParameter("tp"));
 	    com.ysoft.convertxml convert = new com.ysoft.convertxml();
  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        java.io.PrintWriter log = new java.io.PrintWriter(new java.io.FileWriter(gen.getDataLogFileQuery(), true), true);
      	 com.ysoft.subgeneral queryclass = new com.ysoft.subgeneral();
         String spath="C:/apache-tomcat-9.0.39/webapps/3R/document/";
         //String spath="C:/apache-tomcat-7.0.81/webapps/3R/document/";
         String msg="";
         String title="";
         if(tp.equalsIgnoreCase("UPLOADMOVE")){
            title="Movement";
            if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("upload")){
                com.oreilly.servlet.multipart.DefaultFileRenamePolicy df=new com.oreilly.servlet.multipart.DefaultFileRenamePolicy();
            	com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, spath, 10*1024*1024,"ISO-8859-1", df);
                
      		    if(multi.getFile("Fi")!=null){
      			    java.io.File fi=multi.getFile("Fi");      		               
      			    if (fi.exists()){
                        conn.setAutoCommit(false);
                        String fl=fi.getName();
  	            		Workbook workbook = Workbook.getWorkbook(fi);
  	            		Sheet sheet = workbook.getSheet(0);
  	            		boolean next=true;
  	            		int row=0;
                        ConvertDetail:while(next){
				                row++;			                		
			                	try{
				                	try{
						                Cell cell1 = sheet.getCell(0, row);//
						                if(gen.gettable(cell1.getContents()).trim().length()==0) break;
				                	}catch(Exception ie){
				                		break;
				                	}
                                    //No	depo No Container	No BL	Code	Import	Feeder	Tyoe	Size	Consignee	Status	Discharged Time Date Free Time   POL 
                                    String dp =gen.gettable(sheet.getCell(1, row).getContents());//
					                Cell contno = sheet.getCell(2, row);//
					                Cell bl = sheet.getCell(3, row);//
					                Cell code = sheet.getCell(4, row);//
					                Cell sts = sheet.getCell(5, row);//
					                Cell feed = sheet.getCell(6, row);//
					                Cell size = sheet.getCell(7, row);//
					                Cell type = sheet.getCell(8, row);//
					                Cell cosign = sheet.getCell(9, row);//
					                Cell disch = sheet.getCell(11, row);//
                                    String ft = gen.gettable(sheet.getCell(12, row).getContents());//
                                    String pol = gen.gettable(sheet.getCell(13, row).getContents());//
//System.out.println("contno="+contno.getContents()+",bl="+bl.getContents());      		                                     
                                    if(contno.getContents()!=null){
                                      if(contno.getContents().trim().length()==11){
                                          java.util.Vector exist=sgen.getDataQuery(conn,"MOVEMENTEXIST",new String[]{contno.getContents(),gen.getToday("dd-MM-yyyy")});
                                          if(exist.size()==0){
                                              String imp="";
                                              if(bl.getContents()!=null){
                                                if(bl.getContents().length()>1) imp=bl.getContents().substring(0,1);
                                              }
                                              String tps="";
                                              if(code.getContents().trim().endsWith("02")){
                                                tps="W";
                                              }
                                              if(code.getContents().trim().endsWith("01")){
                                                tps="B";
                                              }
                                              if(tps.length()==0){
                                                if(gen.gettable(sts.getContents()).startsWith("S")) tps="S";
                                              }
                                              String co="";
                                              if(cosign.getContents()!=null){
                                                  java.util.Vector findcosig=sgen.getDataQuery(conn,"FINDCODEDESCNOER",new String[]{"CSN",cosign.getContents()});
                                                  if(findcosig.size()==0){
                                                      java.util.Vector mcosig=sgen.getDataQuery(conn,"CODECOSIGNEEMAX",new String[0]);
                                                      String maxc=""+(gen.getInt(gen.gettable(mcosig.get(0)).trim().substring(2))+1);
                                                      if(maxc.length()==2){
                                                          co="CO0"+maxc;
                                                      }else if(maxc.length()==1){
                                                          co="CO00"+maxc;
                                                      }else if(maxc.length()==3){
                                                          co="CO"+maxc;
                                                      }
                                                      
                                                      if(msg.length()==0) msg=sgen.update(conn,"COSIGNEEADD",new String[]{cosign.getContents(),"M",co});//insert ke cosignee
                                                  }else{
                                                    co=gen.gettable(findcosig.get(0)).trim();
                                                  }
                                              }                   
          		                              String di="";
                                              if(disch.getContents()!=null){
                                                  String fromform="dd-MM-yyyy",toform="dd-MM-yyyy";
                                                  String dtt=disch.getContents();
                                                  if(disch.getContents().length()>0 && dtt.length()==5) di=gen.getFormatdate("dd-MM-yyyy",disch.getContents());
                                                  java.util.Vector vdate=gen.getElement('-',dtt+"-");
                                                  
                                                  if(vdate.size()==3){
                                                    String dd=gen.gettable(vdate.get(0));
                                                    if(dd.length()==1) dd="0"+dd;
                                                    String mm=gen.gettable(vdate.get(1));
                                                    if(mm.length()>2){
                                                        fromform="dd-MMM-yyyy";
                                                    }
                                                    if(mm.length()==1) mm="0"+mm;                                            
                                                    String yy=gen.gettable(vdate.get(2));
                                                    if(yy.length()==2) yy="20"+yy;
                                                    di=dd+"-"+mm+"-"+yy;
                                                  }else{
                                                    vdate=gen.getElement('/',dtt+"/");
                                                    if(vdate.size()==3){
                                                      String dd=gen.gettable(vdate.get(0));
                                                      if(dd.length()==1) dd="0"+dd;
                                                      String mm=gen.gettable(vdate.get(1));
                                                      if(mm.length()>2){
                                                          fromform="dd-MMM-yyyy";
                                                      }
                                                      if(mm.length()==1) mm="0"+mm;                                            
                                                      String yy=gen.gettable(vdate.get(2));
                                                      if(yy.length()==2) yy="20"+yy;
                                                      di=dd+"-"+mm+"-"+yy;
                                                    }
                                                  }
                                                  if(!fromform.equalsIgnoreCase(toform)){
                                                    di=sgen.ConvertDateFormat(fromform,toform,di);
                                                  }
                                                  
                                                  if(di.length()==0) msg="Wrong format date (valid format dd/MM/yyyy or dd-MM-yyyy)";
                                                  if(msg.length()>0) break; 
                                              }      
                                                System.out.println("insert into contno="+contno.getContents()+",bl="+bl.getContents()+",co="+co+","+di);
                                              //TrxDate,MOVEID,ContNo,[BLNo],[tpContainer],[Status],[feeder],[Size] ,[TypeCode] ,[Cosignee],[DischDate]                 
                                              String[] cd=new String[]{gen.getToday("dd-MM-yyyy"),"1",contno.getContents(),bl.getContents(),dp,sts.getContents(),feed.getContents(),size.getContents(),type.getContents(),co,di,imp,pol,ft};
                                             System.out.println(java.util.Arrays.toString(cd));
                                              if(msg.length()==0)  msg=sgen.update(conn,"UPLOADMOVEADD",cd);
                                          }
                                      }else{
                                        continue;
                                      }
                                    }else{
                                      continue;
                                    }
                                    if(msg.length()>0) break; 
			                	}catch(Exception ie){
                                    msg="Exception"; 
			                		ie.printStackTrace();
			                		break;
			                	}
                        }
                        //TrfDate,FileName,Filetp,FileSize,UserId,Parm
                        if(msg.length()==0) msg=sgen.update(conn,"UPLOADADD",new String[]{fl,"M",gen.getformatlong(fi.length() / 1000L),gen.gettable(ses.getAttribute("User")),""});
                        if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"UPLOADMOVE",fl});
                        if(msg.length()>0){
                            conn.rollback();
                            msg="(Uploaded File was Failed "+msg+")";
                        }else{
                            conn.commit();
                            msg="(File was Uploaded)";
                        } 
                        
                        conn.setAutoCommit(true);     
      			    }
                }
              }
          }
         if(tp.equalsIgnoreCase("UPLOADJOB")){
            title="Job";
            if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("upload")){
                com.oreilly.servlet.multipart.DefaultFileRenamePolicy df=new com.oreilly.servlet.multipart.DefaultFileRenamePolicy();
            	com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, spath, 10*1024*1024,"ISO-8859-1", df);
                
      		    if(multi.getFile("Fi")!=null){
      			    java.io.File fi=multi.getFile("Fi");      		               
      			    if (fi.exists()){
                        String fl=fi.getName();
                        conn.setAutoCommit(false);
  	            		Workbook workbook = Workbook.getWorkbook(fi);
  	            		Sheet sheet = workbook.getSheet(0);
                        
                        if(gen.gettable(ses.getAttribute("TxtErcode")).equalsIgnoreCase("L")){
      	            		boolean next=true;
      	            		int row=0;
                            int hitkosong=0;
                            String vendor ="",vdesc="";
                            String billto ="",bdesc="";
                            java.util.Vector vdr=sgen.getDataQuery(conn,"DEFAULTVDR",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                            java.util.Vector bil=sgen.getDataQuery(conn,"DEFAULTBILL",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                            if(vdr.size()>0){
                                vendor=gen.gettable(vdr.get(0)).trim();
                                vdesc=gen.gettable(vdr.get(1)).trim();
                            }
                            
                            if(bil.size()>0){
                                billto=gen.gettable(bil.get(0)).trim();
                                bdesc=gen.gettable(bil.get(1)).trim();
                            }
                            
                            ConvertDetail:while(next){
    				                row++;			                		
    			                	try{
    				                	try{
    						                Cell cell1 = sheet.getCell(2, row);//kalo kosong
    						                if(gen.gettable(cell1.getContents()).trim().length()==0){
                                                hitkosong++;
                                                if(hitkosong>10) break;
                                                continue;
                                            }
                                            
    				                	}catch(Exception ie){
    				                		break;
    				                	}
                                        //if logistic -	ID#	Date	Quantity	Item/Acct	Description	Amount	Status	Supplier Inv #	Amt + Tax	Job No.	Linked Customer
                                         
    
    					                String jobno =gen.gettable(sheet.getCell(11, row).getContents()).trim();//
    					                String myob =  gen.gettable(sheet.getCell(2, row).getContents()).trim();//
    					                Cell dat = sheet.getCell(3, row);//
    					                String acct = gen.gettable(sheet.getCell(5, row).getContents()).trim();//
    					                Cell amt = sheet.getCell(7, row);//
                                        String amtx=amt.getContents();
                                        if(amtx.startsWith("Rp")){
                                            amtx=amtx.substring(2);
                                        }
                                        if(amtx.startsWith("(Rp")){
                                            amtx=amtx.substring(3);
                                            if(amtx.endsWith(")"))amtx=amtx.substring(0,amtx.length()-1);
                                            amtx="-"+amtx;                                            
                                        }else if(amtx.startsWith("(")){
                                            amtx=amtx.substring(1);
                                            if(amtx.endsWith(")"))amtx=amtx.substring(0,amtx.length()-1);
                                            amtx="-"+amtx;                                            
                                        }
    					                String cust = gen.gettable(sheet.getCell(12, row).getContents()).trim();//
                                        String note = gen.gettable(sheet.getCell(9, row).getContents()).trim();//supplier inv
                                        if(jobno.length()>0){
                                           if(dat.getContents()==null){
                                                continue;
                                           }
                                           if(dat.getContents().length()==0){
                                                continue;
                                           }
                                          if(acct.indexOf("-")>0){
                                    		  java.util.Vector sc=gen.getElement('-',acct+"-");
                                    		  if(sc.size()>1) acct=gen.gettable(sc.get(0))+gen.gettable(sc.get(1));
                                    		  else acct="";
                                          }
                                          
                                          String di="";
                                          String fromform="dd-MM-yyyy",toform="dd-MM-yyyy";
                                          String dtt=dat.getContents();
                                          if(dat.getContents().length()>0 && dtt.length()==5) di=gen.getFormatdate("dd-MM-yyyy",dat.getContents());
                                          java.util.Vector vdate=gen.getElement('-',dtt+"-");
                                          
                                          if(vdate.size()==3){
                                            String dd=gen.gettable(vdate.get(0));
                                            if(dd.length()==1) dd="0"+dd;
                                            String mm=gen.gettable(vdate.get(1));
                                            if(mm.length()>2){
                                                fromform="dd-MMM-yyyy";
                                            }
                                            if(mm.length()==1) mm="0"+mm;                                            
                                            String yy=gen.gettable(vdate.get(2));
                                            if(yy.length()==2) yy="20"+yy;
                                            di=dd+"-"+mm+"-"+yy;
                                          }else{
                                            vdate=gen.getElement('/',dtt+"/");
                                            //System.out.println(">>"+vdate.size());
                                            if(vdate.size()==3){
                                              String dd=gen.gettable(vdate.get(0));
                                              if(dd.length()==1) dd="0"+dd;
                                              String mm=gen.gettable(vdate.get(1));
                                              if(mm.length()>2){
                                                  fromform="dd-MMM-yyyy";
                                              }
                                              if(mm.length()==1) mm="0"+mm;                                            
                                              String yy=gen.gettable(vdate.get(2));
                                              if(yy.length()==2) yy="20"+yy;
                                              di=dd+"-"+mm+"-"+yy;
                                          //    System.out.println(dtt+",di="+di+",dd="+dd+",mm="+mm+",yy="+yy);
                                            }
                                            
                                          }
                                          if(!fromform.equalsIgnoreCase(toform)){
                                            di=sgen.ConvertDateFormat(fromform,toform,di);
                                          }
                                          if(di.length()==0) msg="Wrong format date (valid format dd/MM/yyyy or dd-MM-yyyy)";
                                          if(msg.length()>0) break; 
                                          
                                          //[Trx_JobSales] ([ErCode],[JobNo],[Seq],[BillTo],[AcctNo],[DK],[Curr],[Amt],[CheckFlag],[IDRAmt] ,[Perc],[FinalAmt],[MYOB],[percflag],[rate],remarks) VAL
                                          java.util.Vector findcust=sgen.getDataQuery(conn,"FINDCODEDESC",new String[]{"CUST",cust,gen.gettable(ses.getAttribute("TxtErcode"))});
                                          if(findcust.size()==0){
                                              java.util.Vector mcosig=sgen.getDataQuery(conn,"CODECUSTOMERMAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                                              String maxc="1";
                                              if(gen.gettable(mcosig.get(0)).trim().length()>1) maxc=""+(gen.getInt(gen.gettable(mcosig.get(0)).trim().substring(1))+1);
                                              String co="";
                                              if(maxc.length()==2){
                                                  co="C0"+maxc;
                                              }else if(maxc.length()==1){
                                                  co="C00"+maxc;
                                              }else if(maxc.length()==3){
                                                  co="C"+maxc;
                                              }                                                      
                                              msg=sgen.update(conn,"CUSTOMERADD",new String[]{cust,gen.gettable(ses.getAttribute("TxtErcode")),co});//insert ke customer
                                              cust=co;
                                          }else{
                                            cust=gen.gettable(findcust.get(0)).trim();
                                          }
                                          if(acct.startsWith("5")||acct.startsWith("23330")){//untuk sales
                                            
                                            java.util.Vector exist=sgen.getDataQuery(conn,"JOBSALESEXIST",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno,acct});
                                            if(exist.size()==0){
                                                  String[] cd=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno,"1",billto,acct,"D","IDR",amtx,"0",amtx,"0",amtx,myob,"0","1","From Upload"};
                                                  if(msg.length()==0) msg=sgen.update(conn,"JOBSALESADD",cd);
                                            }                                                                                                    
                                          }else if(acct.startsWith("4")||acct.startsWith("23310")){//untuk cost
                                            //INSERT INTO [dbo].[Trx_JobCost] ([ErCode] ,[JobNo] ,[Seq] ,[Vendor],[AcctNo],[Invoice] ,[CurrCost],[AmtCost],[CheckFlag],[IDRAmtCost],[PercCost],[FinalCost],[MYOB],[percflag],[rate],remarks) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
                                            java.util.Vector exist=sgen.getDataQuery(conn,"JOBCOSTEXIST",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno,acct});
                                            if(exist.size()==0){
                                                  String[] cd=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno,"1",vendor,acct,"","IDR",amtx,"0",amtx,"0",amtx,myob,"0","1","From Upload"};
                                                  
                                                  if(msg.length()==0) msg=sgen.update(conn,"JOBCOSTADD",cd);
                                            }                                                                                                    
                                          }
                                          //trx_job [SalesCode],[TypeCode],[TrxDate],[BL],[Voyage],[Customer],[Note],[TotSalesAmt],[TotCostAmt],[TotProfit] ,[contno] ,[vesselname],[totpctsales] ,[totpctcost],[ErCode] ,[JobNo]
                                          java.util.Vector existjob=sgen.getDataQuery(conn,"JOBEXIST",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno});
                                          if(existjob.size()==0){
                                              String salescode=jobno.substring(0,2);
                                              String[] cd=new String[]{salescode,"EXP",di,"","",cust,note,"0","0","0","","","0","0","","","","",gen.gettable(ses.getAttribute("TxtErcode")),jobno};
                                              if(msg.length()==0) msg=sgen.update(conn,"JOBNEWADD",cd);
                                          }
                                          String[] cd=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno};
                                          if(msg.length()==0) msg=sgen.update(conn,"JOB_SALESUPD",cd);
                                          if(msg.length()==0) msg=sgen.update(conn,"JOB_SALESUPD2",cd);                                                                
                                        }else{
                                          continue;
                                        }
                                        if(msg.length()>0) break; 
    			                	}catch(Exception ie){
                                        msg="Exception";
    			                		ie.printStackTrace();
    			                		break;
    			                	}
                            }
                        }else{//untuk ercode="M"
      	            		boolean next=true;
      	            		int row=0;
                            int hitkosong=0;
                            int stcol=0;
                            java.util.Vector tampungjob=new java.util.Vector();
                            ConvertDetail:while(next){
    				                row++;			                		
    			                	try{
    				                	try{
    						                Cell cell1 = sheet.getCell(1, row);//kalo kosong
    						                if(gen.gettable(cell1.getContents()).trim().length()==0){
                                                hitkosong++;
                                                if(hitkosong>10) break;
                                                continue;
                                            }
                                            
    				                	}catch(Exception ie){
    				                		break;
    				                	}
                                        
                                        //Date	Job No.	Invoice	TYPE	ACC	DESCRIPTION	VENDOR	BILL TO	Customer	Crncy	" Current Rate "	USD	IDR	VOYAGE NO	COUNTRY	M.BL	FEEDER VESSEL	Remark Contno mother vessel
    					                String jobno =gen.gettable(sheet.getCell(1+stcol, row).getContents()).trim();//
                                     
                                        String invno =gen.gettable(sheet.getCell(2+stcol, row).getContents()).trim();//
                                        String tpp =gen.gettable(sheet.getCell(3+stcol, row).getContents()).trim();//sales-costs
    					                String vendor =  gen.gettable(sheet.getCell(6+stcol, row).getContents()).trim();//
                                        String bill =  gen.gettable(sheet.getCell(7+stcol, row).getContents()).trim();//
                                        String cust =  gen.gettable(sheet.getCell(8+stcol, row).getContents()).trim();//
                                        String curr =  gen.gettable(sheet.getCell(9+stcol, row).getContents()).trim();//
                                        String rate =  gen.gettable(sheet.getCell(10+stcol, row).getContents()).trim();//
    					                Cell dat = sheet.getCell(0+stcol, row);//
    					                String acct = gen.gettable(sheet.getCell(4+stcol, row).getContents()).trim();//
                                        String remarks = gen.gettable(sheet.getCell(5+stcol, row).getContents()).trim();//
                                        if(remarks.length()>50) remarks=remarks.substring(0,50);
    					                Cell amt = sheet.getCell(11+stcol, row);//
                                        Cell idramt = sheet.getCell(12+stcol, row);//
                                        String amtx=idramt.getContents();
                                        if(amtx.startsWith("Rp")){
                                            amtx=amtx.substring(2);
                                        }
                                        if(amtx.startsWith("(Rp")){
                                            amtx=amtx.substring(3);
                                            if(amtx.endsWith(")"))amtx=amtx.substring(0,amtx.length()-1);
                                            amtx="-"+amtx;                                            
                                        }else if(amtx.startsWith("(")){
                                            amtx=amtx.substring(1);
                                            if(amtx.endsWith(")"))amtx=amtx.substring(0,amtx.length()-1);
                                            amtx="-"+amtx;                                            
                                        }
                                        if(curr.length()==0) curr="IDR";
                                        //System.out.println(jobno+","+acct+"="+amtx);
    					                String voy = gen.gettable(sheet.getCell(13+stcol, row).getContents()).trim();//
                                        String bl = gen.gettable(sheet.getCell(15+stcol, row).getContents()).trim();//
                                        String vess = gen.gettable(sheet.getCell(16+stcol, row).getContents()).trim();//
                                        String note = gen.gettable(sheet.getCell(17+stcol, row).getContents()).trim();//
                                        String contno = gen.gettable(sheet.getCell(18+stcol, row).getContents()).trim();//
                                        String mothervessel = gen.gettable(sheet.getCell(19+stcol, row).getContents()).trim();//
                                        String myob="";
                                        if(jobno.length()>0){
                                        
                                           if(dat.getContents()==null){
                                                continue;
                                           }
                                           if(dat.getContents().length()==0){
                                                continue;
                                           }
                                          if(acct.indexOf("-")>0){
                                    		  java.util.Vector sc=gen.getElement('-',acct+"-");
                                    		  if(sc.size()>1) acct=gen.gettable(sc.get(0))+gen.gettable(sc.get(1));
                                    		  else acct="";
                                          }
                                          
                                          String di="";
                                          String fromform="dd-MM-yyyy",toform="dd-MM-yyyy";
                                          String dtt=dat.getContents();
                                          //System.out.println(jobno+",d>"+dtt);
                                          if(dat.getContents().length()>0 && dtt.length()==5) di=gen.getFormatdate("dd-MM-yyyy",dat.getContents());
                                          java.util.Vector vdate=gen.getElement('-',dtt+"-");
                                          if(vdate.size()==3){
                                            String dd=gen.gettable(vdate.get(0));
                                            if(dd.length()==1) dd="0"+dd;
                                            String mm=gen.gettable(vdate.get(1));
                                            if(mm.length()>2){
                                                fromform="dd-MMM-yyyy";
                                            }
                                            if(mm.length()==1) mm="0"+mm;                                            
                                            String yy=gen.gettable(vdate.get(2));
                                            if(yy.length()==2) yy="20"+yy;
                                            di=dd+"-"+mm+"-"+yy;
                                          }else{
                                            vdate=gen.getElement('/',dtt+"/");
                                            if(vdate.size()==3){
                                              String dd=gen.gettable(vdate.get(0));
                                              if(dd.length()==1) dd="0"+dd;
                                              String mm=gen.gettable(vdate.get(1));
                                              if(mm.length()>2){
                                                  fromform="dd-MMM-yyyy";
                                              }
                                              if(mm.length()==1) mm="0"+mm;                                            
                                              String yy=gen.gettable(vdate.get(2));
                                              if(yy.length()==2) yy="20"+yy;
                                              di=dd+"-"+mm+"-"+yy;
                                            }
                                          }
                                          if(!fromform.equalsIgnoreCase(toform)){
                                            di=sgen.ConvertDateFormat(fromform,toform,di);
                                          }
                                          //System.out.println(jobno+",d="+di);   
                                          if(di.length()==0) msg="Wrong format date (valid format dd/MM/yyyy or dd-MM-yyyy)";
                                          if(msg.length()>0) break; 
                                          //trx_job [SalesCode],[TypeCode],[TrxDate],[BL],[Voyage],[Customer],[Note],[TotSalesAmt],[TotCostAmt],[TotProfit] ,[contno] ,[vesselname],[totpctsales] ,[totpctcost],[ErCode] ,[JobNo]
                                          //[Trx_JobSales] ([ErCode],[JobNo],[Seq],[BillTo],[AcctNo],[DK],[Curr],[Amt],[CheckFlag],[IDRAmt] ,[Perc],[FinalAmt],[MYOB],[percflag],[rate],remarks) VAL
                                          java.util.Vector findcust=sgen.getDataQuery(conn,"FINDCODEDESC",new String[]{"CUST",cust,gen.gettable(ses.getAttribute("TxtErcode"))});
                                          if(findcust.size()==0){
                                              java.util.Vector mcosig=sgen.getDataQuery(conn,"CODECUSTOMERMAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                                              String maxc="1";
                                              if(gen.gettable(mcosig.get(0)).trim().length()>1) maxc=""+(gen.getInt(gen.gettable(mcosig.get(0)).trim().substring(1))+1);
                                              String co="";
                                              if(maxc.length()==2){
                                                  co="C0"+maxc;
                                              }else if(maxc.length()==1){
                                                  co="C00"+maxc;
                                              }else if(maxc.length()==3){
                                                  co="C"+maxc;
                                              }                                                      
                                              msg=sgen.update(conn,"CUSTOMERADD",new String[]{cust,gen.gettable(ses.getAttribute("TxtErcode")),co});//insert ke customer
                                              cust=co;
                                          }else{
                                            cust=gen.gettable(findcust.get(0)).trim();
                                          }
                                          java.util.Vector existjob=sgen.getDataQuery(conn,"JOBEXIST",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno});
                                          if(existjob.size()==0){
                                              boolean xexist=false;
                                              for(int xx=0;xx<tampungjob.size();xx+=9){
                                                if(jobno.equalsIgnoreCase(gen.gettable(tampungjob.get(xx+1)).trim())){
                                                    xexist=true;
                                                    continue;
                                                }
                                              }
                                              if(!xexist){
                                                tampungjob.addElement(di);
                                                tampungjob.addElement(jobno);
                                                tampungjob.addElement(cust);
                                                tampungjob.addElement(note);
                                                tampungjob.addElement(bl);
                                                tampungjob.addElement(voy);
                                                tampungjob.addElement(vess);
                                                tampungjob.addElement(contno);
                                                tampungjob.addElement(mothervessel);
                                              }
                                              if(tpp.startsWith("SALES")){//untuk sales
                                                String billto="";
                                                if(bill.length()>0){
                                                    findcust=sgen.getDataQuery(conn,"FINDCODEDESC",new String[]{"BILL",bill,gen.gettable(ses.getAttribute("TxtErcode"))});
                                                    if(findcust.size()==0){
                                                        java.util.Vector mcosig=sgen.getDataQuery(conn,"CODEBILLTOMAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                                                        String maxc="1";
                                                        if(gen.gettable(mcosig.get(0)).trim().length()>1) maxc=""+(gen.getInt(gen.gettable(mcosig.get(0)).trim().substring(1))+1);
                                                        String co="";
                                                        if(maxc.length()==2){
                                                            co="B0"+maxc;
                                                        }else if(maxc.length()==1){
                                                            co="B00"+maxc;
                                                        }else if(maxc.length()==3){
                                                            co="B"+maxc;
                                                        }                                                      
                                                        msg=sgen.update(conn,"BILLTOADD",new String[]{bill,gen.gettable(ses.getAttribute("TxtErcode")),co});//insert ke customer
                                                        bill=co;
                                                    }else{
                                                        bill=gen.gettable(findcust.get(0)).trim();
                                                    }
                                                }
                                                
                                                String seq="1";
                                                java.util.Vector exist=sgen.getDataQuery(conn,"JOBSALESEXIST",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno,acct});
                                                if(exist.size()>0){
                                                    seq=""+(gen.getInt(exist.get(0))+1);
                                                }
                                                String[] cd=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno,seq,bill,acct,"D",curr,amt.getContents(),"0",amtx,"0",amtx,myob,"0",rate,remarks};
                                                if(msg.length()==0) msg=sgen.update(conn,"JOBSALESADD",cd);
                                              }else if(tpp.startsWith("COST")){//untuk cost
                                                String vend="";
                                                if(vendor.length()>0){
                                                    findcust=sgen.getDataQuery(conn,"FINDCODEDESC",new String[]{"VDR",vendor,gen.gettable(ses.getAttribute("TxtErcode"))});
                                                    if(findcust.size()==0){
                                                        java.util.Vector mcosig=sgen.getDataQuery(conn,"CODEVENDORMAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                                                        String maxc="1";
                                                        if(gen.gettable(mcosig.get(0)).trim().length()>1) maxc=""+(gen.getInt(gen.gettable(mcosig.get(0)).trim().substring(1))+1);
                                                        String co="";
                                                        if(maxc.length()==2){
                                                            co="V0"+maxc;
                                                        }else if(maxc.length()==1){
                                                            co="V00"+maxc;
                                                        }else if(maxc.length()==3){
                                                            co="V"+maxc;
                                                        }                                                      
                                                        msg=sgen.update(conn,"VENDORADD",new String[]{vendor,gen.gettable(ses.getAttribute("TxtErcode")),co});//insert ke customer
                                                        vend=co;
                                                    }else{
                                                        vend=gen.gettable(findcust.get(0)).trim();
                                                    }
                                                }
                                                
                                                String seq="1";
                                                java.util.Vector exist=sgen.getDataQuery(conn,"JOBCOSTEXIST",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno,acct});
                                                if(exist.size()>0){
                                                    seq=""+(gen.getInt(exist.get(0))+1);
                                                }
                                            //INSERT INTO [dbo].[Trx_JobCost] ([ErCode] ,[JobNo] ,[Seq] ,[Vendor],[AcctNo],[Invoice] ,[CurrCost],[AmtCost],[CheckFlag],[IDRAmtCost],[PercCost],[FinalCost],[MYOB],[percflag],[rate],remarks) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
                                                String[] cd=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno,seq,vend,acct,invno,curr,amt.getContents(),"0",amtx,"0",amtx,myob,"0",rate,remarks};
                                                if(msg.length()==0) msg=sgen.update(conn,"JOBCOSTADD",cd);
                                              }
                                          }
                                          
                                        }else{
                                          continue;
                                        }
                                        if(msg.length()>0) break; 
    			                	}catch(Exception ie){
                                        msg="Exception";
    			                		ie.printStackTrace();
    			                		break;
    			                	}
                            }//end while next
                            for(int xx=0;xx<tampungjob.size();xx+=9){
                                String di=gen.gettable(tampungjob.get(xx));
                                String jobno=gen.gettable(tampungjob.get(xx+1));
                                String cust=gen.gettable(tampungjob.get(xx+2));
                                String note=gen.gettable(tampungjob.get(xx+3));
                                String bl=gen.gettable(tampungjob.get(xx+4));
                                String voy=gen.gettable(tampungjob.get(xx+5));
                                String vess=gen.gettable(tampungjob.get(xx+6));
                                String contno=gen.gettable(tampungjob.get(xx+7));
                                String mothervessel=gen.gettable(tampungjob.get(xx+8));
                                String tpe="EXP";
                                if(jobno.startsWith("I")) tpe="IMP";
                                String[] cd=new String[]{"",tpe,di,bl,voy,cust,note,"0","0","0",contno,vess,"0","0","","","",mothervessel,gen.gettable(ses.getAttribute("TxtErcode")),jobno};
                                if(msg.length()==0) msg=sgen.update(conn,"JOBNEWADD",cd);
                            
                                cd=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),jobno};
                                if(msg.length()==0) msg=sgen.update(conn,"JOB_SALES2",cd);//untuk trx_jobsales
                                if(msg.length()==0) msg=sgen.update(conn,"JOB_COST2",cd);  //untuk trx_jobcost

                                if(msg.length()==0) msg=sgen.update(conn,"JOB_SALESUPD",cd);
                                if(msg.length()==0) msg=sgen.update(conn,"JOB_SALESUPD2",cd);                                                                                                
                            }
                        }//end ercode=L
                        //TrfDate,FileName,Filetp,FileSize,UserId,Parm
                        if(msg.length()==0)  msg=sgen.update(conn,"UPLOADADD",new String[]{fl,"M",gen.getformatlong(fi.length() / 1000L),gen.gettable(ses.getAttribute("User")),""});
                        if(msg.length()==0)  msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"UPLOADJOB",fl});
                        if(msg.length()>0){
                            conn.rollback();
                            msg="(Uploaded File was Failed "+msg+")";
                        }else{
                            conn.commit();
                            msg="(File was Uploaded)";
                        } 
                        conn.setAutoCommit(true);
      			    }
                }
              }
          }
         java.util.Vector combo1=new java.util.Vector();
         if(tp.equalsIgnoreCase("UPLOADRATE")){    
            title="Rate Filing";     
            combo1=sgen.getDataQuery(conn,"TRADERATE",new String[0]);
            if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("upload")){
                com.oreilly.servlet.multipart.DefaultFileRenamePolicy df=new com.oreilly.servlet.multipart.DefaultFileRenamePolicy();
            	com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, spath, 10*1024*1024,"ISO-8859-1", df);
                
      		    if(multi.getFile("Fi")!=null){
      			    java.io.File fi=multi.getFile("Fi");      		               
      			    if (fi.exists()){
                        conn.setAutoCommit(false);
                        String fl=fi.getName();
                        String tr=gen.gettable(multi.getParameter("Y10"));
                        if(tr.trim().length()==0){
                            tr=gen.gettable(multi.getParameter("Y11"));
                        }
                        String eff=gen.gettable(multi.getParameter("Y12"));
                        String exp=gen.gettable(multi.getParameter("Y13"));
                        String bunk=gen.gettable(multi.getParameter("Y14"));
  	            		Workbook workbook = Workbook.getWorkbook(fi);
  	            		Sheet sheet = workbook.getSheet(0);
  	            		boolean next=true;
  	            		int row=0;
                        ConvertDetail:while(next){
				                row++;			                		
			                	try{
				                	try{
						                Cell cell1 = sheet.getCell(0, row);//
						                if(gen.gettable(cell1.getContents()).trim().length()==0) break;
				                	}catch(Exception ie){
				                		break;
				                	}
                                    //Commodity	Origin	Destination	Shipment kind	Currency	Equipment	Receipt Term	Delivery Term	Extend	CALBASE	20 Amt	40 Amt	45 Amt	Inclusion 
                                    Cell Comm = sheet.getCell(0, row);//
					                Cell Origin = sheet.getCell(1, row);//
					                Cell Destination = sheet.getCell(2, row);//
					                Cell Curr = sheet.getCell(4, row);//
					                Cell size20 = sheet.getCell(10, row);//
					                Cell size40 = sheet.getCell(11, row);//
					                Cell size45 = sheet.getCell(12, row);//
					                Cell incl = sheet.getCell(13, row);//
                                    if(Origin.getContents()!=null){
                                        //[Commodity] ,[Effective] ,[Expired] ,[Trade],[Bunker],[Origin],[Destination],[Curr],[20Amt] ,[40Amt] ,[45Amt],[Inclusion]) VA                 
                                        String[] cd=new String[]{Comm.getContents(),eff,exp,tr,bunk,Origin.getContents(),Destination.getContents(),Curr.getContents(),size20.getContents(),size40.getContents(),size45.getContents(),incl.getContents()};
                                        if(msg.length()==0) msg=sgen.update(conn,"UPLOADRATEADD",cd);
                                    }else{
                                      continue;
                                    }
                                    if(msg.length()>0) break; 
			                	}catch(Exception ie){
                                    msg="Exception";
			                		ie.printStackTrace();
			                		break;
			                	}
                        }
                        //TrfDate,FileName,Filetp,FileSize,UserId,Parm
                        if(msg.length()==0) msg=sgen.update(conn,"UPLOADADD",new String[]{fl,"M",gen.getformatlong(fi.length() / 1000L),gen.gettable(ses.getAttribute("User")),""});
                        if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"UPLOADRATE",fl+"|"+tr+"|"+eff+"|"+exp+"|"+bunk+"|"});
                        if(msg.length()>0){
                            conn.rollback();
                            msg="(Uploaded File was Failed, "+msg+")";
                        }else{
                            conn.commit();
                            msg="(File was Uploaded)";
                        } 
                        conn.setAutoCommit(true);
      			    }
                }
              }
          }
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin" >
        <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1>Upload <%=title%> <%=msg%></h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
									<div id="user-profile-3" class="user-profile row">
                                        <form name = "BGA" action="upload.jsp?tp=<%=tp%>&act=upload" method="post"  ENCTYPE="multipart/form-data">
                                        <div class="col-sm-offset-1 col-sm-10">
                                            <label class="control-label">File in xls format:</label>
                                            <label class="control-label">&nbsp;<input type="file"  accept=".xls" name="Fi" size="40" id="Fi"  tabindex="1" maxlength="60" value="<%=Gen.gettable(request.getParameter("Fi"))%>"  ></label>
                                            <%if(tp.equalsIgnoreCase("UPLOADRATE")){%>
										</div>                  
										<div class="col-sm-offset-1 col-sm-10">
                                            <label class="control-label">*Trade:<input type="text" id="Y11" maxlength="20" size="10" name="Y11"  placeholder="New Trade" value="<%=Gen.gettable(request.getParameter("Y11")).trim()%>"/>&nbsp;<select name="Y10"><option></option><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(Gen.gettable(request.getParameter("Y10")).trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
											<label class="control-label">&nbsp;*Effective Date:<input class="input-medium date-picker" name="Y12"  id="Y12" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(request.getParameter("Y12"))%>" placeholder="dd-mm-yyyy"/> </label>
											<label class="control-label">&nbsp;*Expired Date:<input class="input-medium date-picker" name="Y13"  id="Y13" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(request.getParameter("Y13"))%>" placeholder="dd-mm-yyyy" /> </label>
											<label class="control-label">&nbsp;Bunker:<input type="text" id="Y14" maxlength="6" size="5" name="Y14"  placeholder="Bunker" value="<%=Gen.gettable(request.getParameter("Y14")).trim()%>"/></label>
                                            <%}%>
                                            <label class="control-label">&nbsp;<input type="button" value="Upload" name="act" onclick="validasi()"> </label>
                                        </div>
                                       </form>
                                 </div>
                            </div>
                      </div>
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
		<script src="assets/js/jquery.dataTables.min.js"></script>
		<script src="assets/js/jquery.dataTables.bootstrap.min.js"></script>
		<script src="assets/js/dataTables.buttons.min.js"></script>
		<script src="assets/js/buttons.flash.min.js"></script>
		<script src="assets/js/buttons.html5.min.js"></script>
		<script src="assets/js/buttons.print.min.js"></script>
		<script src="assets/js/buttons.colVis.min.js"></script>
		<script src="assets/js/dataTables.select.min.js"></script>

		<!-- ace scripts -->
		<script src="assets/js/ace-elements.min.js"></script>
		<script src="assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
			jQuery(function($) {
				var active_class = 'active';
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
			
				
			
				/********************************/
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
				/***************/
				
				
				
				
				
				/**
				//add horizontal scrollbars to a simple table
				$('#simple-table').css({'width':'2000px', 'max-width': 'none'}).wrap('<div style="width: 1000px;" />').parent().ace_scroll(
				  {
					horizontal: true,
					styleClass: 'scroll-top scroll-dark scroll-visible',//show the scrollbars on top(default is bottom)
					size: 2000,
					mouseWheelLock: true
				  }
				).css('padding-top', '12px');
				*/
			
			
			})
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
            function  validasi(){
                  var canin=true;
                  if(document.BGA.Fi.value==""){
                      alert("File must be Filled!");
                      canin=false;
                  }
                  <%if(tp.equalsIgnoreCase("UPLOADRATE")){%>
                  if(document.BGA.Y10.value=="" && document.BGA.Y11.value==""){
                      alert("Trade must be Filled!");
                      canin=false;
                  }else if(document.BGA.Y10.value!="" && document.BGA.Y11.value!=""){
                      alert("Must Fill The New Trade Or Old Trade");
                      canin=false;
                  }else if(document.BGA.Y12.value==""){
                      alert("Effective Date must be filled!");
                      canin=false;
                  }else if(document.BGA.Y13.value==""){
                      alert("Expired Date must be filled");
                      canin=false;
                  }
                  if(document.BGA.Y12.value!="" && document.BGA.Y13.value!=""){
                       var s1 = SetTime(Y12.value,"D");
                       var s2 = SetTime(Y13.value,"D");
                       if(s1>s2){
                            alert("Invalid Effective Date. Valid Input (Expired Date >= Effective Date)");
                            canin=false;
                       }
                  }
                  <%}%>
                  if(canin){
                      BGA.submit();
                  }
            }
            
         	function closed(){
        		window.close();
        	}
		</script>
	</body>
</html>
