<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
     <%
     request.setCharacterEncoding("utf-8");
      %>
<!DOCTYPE html>
<html>
<%@ include file="../include/head.jsp"%>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>

<!-- 데이터 테이블 -->
<!-- 데이터 테이블 css -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" />

<script src="https://cdn.datatables.net/t/bs-3.3.6/jqc-1.12.0,dt-1.10.11/datatables.min.js"></script>

<script src="https://code.jquery.com/jquery-3.5.1.js"></script>

<script src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>

<script src=https://cdn.datatables.net/buttons/1.5.2/js/dataTables.buttons.min.js></script>
<!--  이거 없으면 버튼 안생김  -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<!--  //엑셀 -->
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.html5.min.js"></script>
<!-- // 카피+ pdf -->
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.print.min.js"></script>
<!--  // 프린트 -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<!--  // pdf -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<!--  //pdf -->

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>

<!-- datatable-editor js 파일 -->
<script type="text/javascript" src="../resources/js/view/admin/datatable-editor.js"></script>
<script type="text/javascript">
/* 상품 조회 데이터 테이블 */
var	table = null;
$(document).ready(function() {
   table= $('#foo-table').DataTable({
    	"scrollY":        "200px",
        "scrollCollapse": true,
        "paging":         false,
        dom: 'Blfrtip',
  
		buttons: [
			{
				extend:'excel',
				text:'excel',
				filename:'상품관리',
				title:'오름마켓 상품목록'
			},
			{
				extend:'copy',
				text:'copy',
				title:'상품목록'
			},			
                'pdf', 'print'
            ]
    	});
   
   datatableEdit({
		dataTable : table,
		columnDefs : [
			
			{
				targets : 4
			},
			{
				targets : 5
			}
			
		],
		onEdited : function(prev, changed, index, cell) {
		
           console.log(prev, changed, index, cell);
           console.log(prev );
           console.log(changed);
           console.log(index);
           console.log(index['column']);
           
           var _value = changed;
           var _result = null;
           
           if(index['column']==4){
           	_result='quantity';
           }else if (index['column']==5){
           	_result='prodSize';
           }else if (index['column']==6){
           	_result='color';
           }else if (index['column']==9){
           	_result='prodstatus';
           }
          
           var  date =  index['row'];
           var date1 = date+1;
          
           var tr = $("#foo-table tr:eq("+date1+")");
           console.log(tr);
           var _prodNum = tr.find('td:eq(0)').text();
           var _optionNum = tr.find('td:eq(1)').text();
           var _quantity = tr.find('td:eq(4)').text();
           var _prodSize = tr.find('td:eq(5)').text();
           
            $.ajax({
               type : 'get',
               url : 'updateOption.do',
               data : {
               	optionNum : _optionNum,
               	prodNum : _prodNum,
               	quantity : _quantity,
               	prodSize : _prodSize

               	
               },
               success : function(data) {
               	if ("ok"== (data)) {
               		console.log("수정완료");

					} else {
						console.log("수정 실패");
					};
               	
               }
            })  
		}
	});
   
     $('#foo-table tbody').on( 'click', 'tr', function () {
	    if ( $(this).hasClass('selected') ) {
	        $(this).removeClass('selected');
	    }
	    else {
	        table.$('tr.selected').removeClass('selected');
	        $(this).addClass('selected');
	    }
	}); 

   
});
/* 중고품 요청폼 데이터 테이블 */
var	table2 = null;
$(document).ready(function() {
	table2=$('#foo-table2').DataTable({
		pagingType:"full_numbers",
    	   autoWidth: false,
		dom : 'Blfrtip',
		buttons : [ {
			extend : 'excel',
			text : 'excel',
			filename : '회원정보',
			title : '산오름 회원정보'
		}, {
			extend : 'copy',
			text : 'copy',
			title : '회원정보입니다.'
		}, 'pdf', 'print' ]
	});
	  $('#foo-table tbody2').on( 'click', 'tr', function () {
		    if ( $(this).hasClass('selected1') ) {
		        $(this).removeClass('selected1');
		    }
		    else {
		        table.$('tr.selected1').removeClass('selected1');
		        $(this).addClass('selected1');
		    }
		}); 
});
	
	// 데이터테블 함수 끝----------------------------------------------------------------

	$(function insertProdMsg() { // 상품등록알림창
		var insertMsg = "<c:out value="${msg}" />";
		if (insertMsg == "ok") {
			alert("상품 등록 완료");
		}
	});




	//상품 상태 수정
	function prodStatus1(value, optionNum){
		var _result = 'prodStatus';
		var _optionNum = optionNum;
		var _prodStatus = value;
	$.ajax({
        type : 'get',
        url : 'updateDateProdOption.do',
        data : {
        	result : _result,
        	optionNum : _optionNum,
        	prodStatus : _prodStatus
        },
        success : function(data) {
        	if ("ok"== (data)) {
        		console.log("수정완료");
        		//window.location.reload(true);
				} else {
					console.log("수정 실패");
				};
       	 }
     })   
	
	};
	
	//상품 색상 수정
	function prodColor1(value, optionNum){
		var _result = 'color';
		var _optionNum = optionNum;
		var _color = value;
	$.ajax({
        type : 'get',
        url : 'updateDateProdOption.do',
        data : {
        	result : _result,
        	optionNum : _optionNum,
        	color : _color
        },
        success : function(data) {
        	if ("ok"== (data)) {
        		console.log("수정완료");
        		//window.location.reload(true);
				} else {
					console.log("수정 실패");
				};
       	 }
     })   
	
	};
	
	//상품 상세보기
	function viewProd (optionNum, prodNum){
		window.open('viewProdList.do?optionNum='+optionNum+'&prodNum='+prodNum, '상품상세정보','width=700px,height=800px,scrollbars=yes');
		window.location.reload(true);
	};
	
	//중고품 상세보기
	function viewUsedList (prodNum, userNum){
		window.open('viewUsedList.do?prodNum='+prodNum+'&userNum='+userNum, '중고품거래요청','width=800px,height=800px,scrollbars=yes');
		window.location.reload(true);
	};
	
// --------------------------상품등록

    //1차 분류 선택시 2차 분류 셀렉트
    function selectprodcategory1(value){
        $("#prodcategory2").empty();

        if(value=='a'){
            $("#prodcategory2").append("<br>"+ "<select name='prodcategory2' class='basic_btn btn-primary' onchange='selectprodcategory2(this.value)'>"
                +"<option value=' '>2차분류 </option>"
                +"<option value='d'>상의</option>"
                +"<option value='e'>하의</option>"
                +"<option value='f'>아우터</option>"
                +"</select>"
            );
        }else if (value=='b'){
            $("#prodcategory2").append("<br>"+ "<select name='prodcategory2' class='basic_btn btn-primary' onchange='selectprodcategory2(this.value)'>"
                +"<option value=' '>2차분류 </option>"
                +"<option value='g'>모자</option>"
                +"<option value='h'>양말</option>"
                +"<option value='i'>가방</option>"
                +"<option value='j'>신발</option>"
                +"</select>"
            );
        }else if (value=='c') {
            $("#prodcategory2").append("<br>"+ "<select name='prodcategory2' class='basic_btn btn-primary' onchange='selectprodcategory2(this.value)'>"
                +"<option value=' '>2차분류 </option>"
                +"<option value='k'>스틱</option>"
                +"<option value='k'>장갑</option>"
                +"<option value='k'>아이젠</option>"
                +"<option value='k'>보호대</option>"
                +"</select>"
            );
        }
    }

    //2차 분류 선택시 3차 분류 셀렉트
    function selectprodcategory2(value){
        $("#prodcategory3").empty();
        if(value=='d'){
            $("#prodcategory3").append("<br>"+ "<select name='prodcategory3' class='basic_btn btn-primary' >"
                +"<option value=' '>3차분류 </option>"
                +"<option value='15'>반팔</option>"
                +"<option value='16'>긴팔</option>"
                +"<option value='17'>후드</option>"
                +"</select>"
            );
        }else if (value=='e'){
            $("#prodcategory3").append("<br>"+ "<select name='prodcategory3' class='basic_btn btn-primary'>"
                +"<option value=' '>3차분류 </option>"
                +"<option value='18'>반바지</option>"
                +"<option value='19'>긴바지</option>"
                +"</select>"
            );
        }else if (value=='f') {
            $("#prodcategory3").append("<br>"+ "<select name='prodcategory3' class='basic_btn btn-primary' >"
                +"<option value=' '>3차분류 </option>"
                +"<option value='20'>패딩</option>"
                +"<option value='21'>야상</option>"
                +"<option value='22'>바람막이</option>"
                +"</select>"
            );
        }else if (value=='g') {
            $("#prodcategory3").append("<br>"+ "<select name='prodcategory3' class='basic_btn btn-primary'>"
                +"<option value=' '>3차분류 </option>"
                +"<option value='23'>비니</option>"
                +"<option value='24'>캡모자</option>"
                +"<option value='25'>정글모</option>"
                +"<option value='26'>썬캡</option>"
                +"</select>"
            );
        }else if (value=='h') {
            $("#prodcategory3").append("<br>"+ "<select name='prodcategory3' class='basic_btn btn-primary' >"
                +"<option value=' '>3차분류 </option>"
                +"<option value='27'>긴양말</option>"
                +"<option value='28'>반양말</option>"
                +"<option value='29'>발가락양말</option>"
                +"</select>"
            );
        }else if (value=='i') {
            $("#prodcategory3").append("<br>"+ "<select name='prodcategory3' class='basic_btn btn-primary' >"
                +"<option value=' '>3차분류 </option>"
                +"<option value='30'>백팩</option>"
                +"<option value='31'>크로스백</option>"
                +"</select>"
            );
        }else if (value=='j') {
            $("#prodcategory3").append("<br>"+ "<select name='prodcategory3' class='basic_btn btn-primary'>"
                +"<option value=' '>3차분류 </option>"
                +"<option value='32'>등산화</option>"
                +"</select>"
            );

        }else if (value=='k') {
            $("#prodcategory3").append("<br>"+ "<select name='prodcategory3' class='basic_btn btn-primary'>"
                +"<option value=' '>3차분류 </option>"
                +"<option value='11'>스틱</option>"
                +"<option value='12'>장갑</option>"
                +"<option value='13'>아이젠</option>"
                +"<option value='14'>보호대</option>"
                +"</select>"
            );
        }
    };
    var cnt3=1;
    
    //옵션 추가
    function addOption(){
        $("#sizeMain").append("<br><br>"+"<label for='title'>색상:</label><select name='color[]'class='basic_btn btn-warning dropdown-toggle'>"
                +"<option value=' '>color</option>"
                +"<option value='white'>white</option>"
                +"<option value='black'>black</option>"
                +"<option value='red'>red</option>"
                +"<option value='blue'>blue</option>"
                +"<option value='ogrange'>ogrange</option>"
                +"<option value='yellow'>yellow</option>"
                +"<option value='green'>green</option>"
                +"<option value='violet'>violet</option>"
                +"<option value='pink'>pink</option>"
                +"<option value='navy'>navy</option>"
                +"<option value='gray'>gray</option>"
                +"<option value='etc'>etc</option>"
            +"</select>"
           +"<label for='title'>사이즈:</label>"
	       +"<input type='text' name='prodSize[]' value=''><br>"
	       +"<label for='title'>수량:</label>"
	       +"<input type='text' name='quantity[]' value=''>"

        );
        cnt3++;
    };
</script>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

  <!-- Main Header -->
  <%@ include file="../include/main_header.jsp" %>
  <!-- Left side column. contains the logo and sidebar -->
  <%@ include file="../include/left_column.jsp" %>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
  	<section class="content-header">
     
        <small>상품 관리</small>
     
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">Forms</a></li>
        <li class="active">Editors</li>
      </ol>
    </section>

    <!-- Main content -->
 <section class="content">
      <div class="row">
        <div class="col-md-12">
          <div class="box box-info collapsed-box">
            <div class="box-header">
              <h3 class="box-title">상품 등록
                <small></small>
              </h3>
              <!-- tools box -->
              <div class="pull-right box-tools">
                <button type="button" class="btn btn-info btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                  <i class="fa fa-minus"></i></button>
                <button type="button" class="btn btn-info btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                  <i class="fa fa-times"></i></button>
              </div>
              <!-- /. tools -->
            </div>
            <!-- /.box-header -->
            <div class="box-body pad" style="">
     			 <form action="insertProd.do" method="post" enctype="multipart/form-data">
                    <table class="table table-boardered">
                        <tr>
                            <th>상품 분류</th>
                            <td>
                                <div>
                                    <select name="prodcategory1" class="basic_btn btn-primary" onchange="selectprodcategory1(this.value)">
                                        <option value=" ">1차 분류</option>
                                        <option value="a">의류</option>
                                        <option value="b">잡화</option>
                                        <option value="c">등산용품</option>
                                    </select>
                                </div>
                                <!-- 2차 분류 생성 -->
                                <div id="prodcategory2" >
                                </div>
                                <!--3차 분류 생성  -->
                                <div id="prodcategory3" >
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <th>상품명</th>
                            <td><input type="text" class="form-control" name="name" placeholder="상품이름"></td>
                        </tr>
                        <tr>
                            <th>상품설명</th>
                            <td><input type="text" class="form-control" name="content" placeholder="상품설명"></td>
                        </tr>
                        <tr>
                            <th>가격</th>
                            <td><input type="text" class="form-control" name="price"placeholder="가격"></td>
                        </tr>
                        <tr>
                            <th>상품 옵션 </th>
                            <td>
                                <button  type="button" id="_addSize" class="basic_btn1 btn-danger btn-xs"  onClick="addOption()" >옵션 추가</button>
                                <div id="sizeMain">
                                    <label for="title">색상:</label>
                                    <select name="color[]"class="basic_btn btn-warning dropdown-toggle">
                                        <option value=" ">color</option>
                                        <option value="white">white</option>
                                        <option value="black">black</option>
                                        <option value="red">red</option>
                                        <option value="blue">blue</option>
                                        <option value="ogrange">ogrange</option>
                                        <option value="yellow">yellow</option>
                                        <option value="green">green</option>
                                        <option value="violet">violet</option>
                                        <option value="pink">pink</option>
                                        <option value="navy">navy</option>
                                        <option value="gray">gray</option>
                                        <option value="etc">etc</option>
                                    </select>
                                    <label for="title">사이즈:</label>
                                    <input type="text" name="prodSize[]" value=""><br>
                                    <label for="title">수량:</label>
                                    <input type="text" name="quantity[]" value="">

                                </div>
                            </td>
                        </tr>

                        <tr>
                            <th>상품구분</th>
                            <td>
                                <input type="radio"  name="type" value="1">신상품 &nbsp;&nbsp;
                                <input type="radio"  name="type" value="2">중고품&nbsp;&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <th>상품상태</th>
                            <td>
                                <input type="radio"  name="prodStatus" value="1">판매중 &nbsp;&nbsp;
                                <input type="radio"  name="prodStatus" value="2">품절&nbsp;&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <th>대표 이미지</th>
                            <td>
                                <input type='file' id="file" name='file' multiple maxlength="3" />
                            </td>
                        </tr>
                        <tr>
                            <th>상세 이미지</th>
                            <td>
                                <input type='file' id="file2" name='file2' multiple  maxlength="1"/>
                            </td>
                        </tr>
                     
                        <tr>
                            <td colspan="2">
                              <center>
                                <input class="btn btn-primary" type="submit"  value="등록"/>
                                 </center>
                            </td>
                        </tr>
                       
                    </table>
                </form>
            </div>
          </div>
          <!-- /.box -->
          <!-- 중고품 요청폼 -->
           <div class="box box-info">
            <div class="box-header">
              <h3 class="box-title">중고품 관리
                <small></small>
              </h3>
              <!-- tools box -->
              <div class="pull-right box-tools">
                <button type="button" class="btn btn-info btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                  <i class="fa fa-minus"></i></button>
                <button type="button" class="btn btn-info btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                  <i class="fa fa-times"></i></button>
              </div>
              <!-- /. tools -->
            </div>
            <!-- /.box-header -->
            <div class="box-body pad" style="">
		               <form action="selectUsedProd.do" method="get">
					<div class="input-group margin">
						<div class="input-group-btn">
							<select name="searchOption" id="searchOption"class="btn btn-info dropdown-toggle" >
								<option value="all">전체조회</option>
								<option value="p_prodName">상품명</option>
								<option value="p_prodNum">상품번호</option>
								<option value="u_userNum">고객번호</option>
								<option value="a">거래요청</option>
								<option value="b">취소상품</option>
								<option value="c">승인상품</option>
							</select>
						</div>
							<input type="text" name="key_word" id="key_word"class="form-control" placeholder="조회내용을 입력하세요">
								<span class="input-group-btn">
		                    	 	<button type="submit" id="serch"class="btn btn-info btn-flat" >조회</button>
		                    	</span>
						</div>
					</form>
		       <div class="box">
		    
		            <!-- /.box-header -->
				<div class="box-body">
						 <!-- 데이터 테이블 -->
               <div id="example1_wrapper"class="dataTables_wrapper form-inline dt-bootstrap">
                           <table id="foo-table2" class="display" style="width:100%">
                              <thead align=center>
                              <tr>
                                 <th>요청일자</th>
                                 <th>상품번호</th>
                                 <th>고객번호</th>
                                 <th>상품정보</th>
                                 <th>이미지</th>
                                 <th>상태</th>
                                 <th>상세보기</th>
                              </tr>
                              </thead>
                               <tbody align=center>
                                     <c:forEach var="used" items="${used}" >   
                                     <tr>
                                       <td>${used.createdAtString}</td>
                                       <td>${used.prodNum}</td>
                                       <td>${used.userNum}</td>
                                   
                                       <td>
                                           <strong>상품명:${used.name}</strong><br>
                                           <strong>판매가격:${used.priceString}</strong><br>
                                           <strong>카테고리:${used.prodcategorynumString}</strong><br>
                                       </td>
                                       <td>
                                          <strong><img src="http://localhost:8090/resources/img/${used.pcontent}" style="width: 80px; height: 80px; display: block;"></strong><br>
                                       </td>
                                       <td>${used.prodstatusString}</td>
                                   <td><button class="btn btn-primary btn-xs" id="viewUsedList" onclick="viewUsedList(${used.prodNum},${used.userNum})" >상세보기</button></td>      
                                     </tr>
                                      </c:forEach>
                                     </tbody>
                           </table>
                        </div>
                        <!--// 데이터 테이블  -->
					</div>
		            <!-- /.box-body -->
		          	  </div>    
         
            		</div>
          		</div>
          		<!--// 중고품 요청폼 -->
			<!-- 상품조회폼 -->
          <div class="box box-info">
            <div class="box-header">
              <h3 class="box-title">상품 조회
                <small></small>
              </h3>
              <!-- tools box -->
              <div class="pull-right box-tools">
                <button type="button" class="btn btn-info btn-sm" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
                  <i class="fa fa-minus"></i></button>
                <button type="button" class="btn btn-info btn-sm" data-widget="remove" data-toggle="tooltip" title="" data-original-title="Remove">
                  <i class="fa fa-times"></i></button>
              </div>
              <!-- /. tools -->
            </div>
            <!-- /.box-header -->
            <div class="box-body pad" style="">
            <form action="selectProd.do" method="get">
			<div class="input-group margin">
				<div class="input-group-btn">
					<select name="searchOption" id="searchOption"class="btn btn-info dropdown-toggle" >
						<option value="all">전체조회</option>
						<option value="name">상품명</option>
						<option value="type1">신제품</option>
						<option value="type2">중고품</option>
						<option value="prodstatus1">판매중</option>
						<option value="prodstatus2">품절</option>
						<option value="prodcategorynum1">의류</option>
						<option value="prodcategorynum2">잡화</option>
						<option value="prodcategorynum3">등산용품</option>
					</select>
				</div>
					<input type="text" name="key_word" id="key_word"class="form-control" placeholder="조회내용을 입력하세요">
						<span class="input-group-btn">
                    	 	<button type="submit" id="serch"class="btn btn-info btn-flat" >조회</button>
                    	</span>
				</div>
			</form>
       <div class="box">
    
            <!-- /.box-header -->
		<div class="box-body">
				<div id="example1_wrapper" class="dataTables_wrapper form-inline dt-bootstrap">
					<div class="row">
						<div>
						
						<!-- 	<button id="button" class='btn btn-danger btn-xs'>Delete</button> -->
						
							<table id="foo-table" class="display" style="width:100%">
								<thead>
								<tr>
									<th>번호</th>
									<th>옵션번호</th>
									<th>상품명</th>
									<th>가격</th>
									<th>재고</th>
									<th>사이즈</th>
									<th>색상</th>
									<th>타입</th>
									<th>분류</th>
									<th>상태</th>
									<th>등록일</th>
									<th>상세 보기 </th>
								</tr>
								</thead>
								 <tbody>
					                <c:forEach var="prod" items="${list}" >   
					                <tr>
					                  <td>${prod.prodNum}</td>
					                  <td>${prod.optionNum}</td>
					                  <td>${prod.name}</td>
					                  <td>${prod.priceString}</td>
					                  <td>${prod.quantity}</td>
					                  <td>${prod.prodsize}</td>
									  <td>
					                   <select  id="prodStatus1" class="basic_btn btn btn-default" onchange="prodColor1(this.value,${prod.optionNum})">
											<option value="white" ${prod.color == 'white' ? 'selected="selected"' : ''}>white</option>
											<option value="black" ${prod.color == 'black' ? 'selected="selected"' : ''}>black</option>
											<option value="red" ${prod.color == 'red' ? 'selected="selected"' : ''}>red</option>
											<option value="blue" ${prod.color == 'blue' ? 'selected="selected"' : ''}>blue</option>
											<option value="ogrange" ${prod.color == 'ogrange' ? 'selected="selected"' : ''}>ogrange</option>
											<option value="yellow" ${prod.color == 'yellow' ? 'selected="selected"' : ''}>yellow</option>
											<option value="green" ${prod.color == 'green' ? 'selected="selected"' : ''}>green</option>
											<option value="violet" ${prod.color == 'violet' ? 'selected="selected"' : ''}>violet</option>
											<option value="pink" ${prod.color == 'pink' ? 'selected="selected"' : ''}>pink</option>
											<option value="navy" ${prod.color == 'navy' ? 'selected="selected"' : ''}>navy</option>
											<option value="gray" ${prod.color == 'gray' ? 'selected="selected"' : ''}>gray</option>
											<option value="etc" ${prod.color == 'etc' ? 'selected="selected"' : ''}>etc</option>
										</select>
										</td>
					                  <td>${prod.typeString}</td>
					                  <td>${prod.prodcategorynumString}</td>
					                 <td>
					                 	<select  id="prodStatus1" class="basic_btn btn btn-default" onchange="prodStatus1(this.value,${prod.optionNum})">
											<option value="1"${prod.prodstatusString == '판매중' ? 'selected="selected"' : ''}>판매중</option>
											<option value="2"${prod.prodstatusString == '품절' ? 'selected="selected"' : ''}>품절</option>
										</select>
									</td>
									
					                  <td>${prod.createdAtString}</td>
					                  <td><button class="btn btn-primary btn-xs" id ="view" onclick="viewProd(${prod.optionNum},${prod.prodNum})">상세보기</button></td> 		
					                </tr>
					                 </c:forEach>
					                </tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
            <!-- /.box-body -->
          	  </div>              
            </div>
          </div>
          <!-- //상품조회폼 -->
          
          
        </div>
        <!-- /.col-->
      </div>
      <!-- ./row -->
    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->

  <!-- Main Footer -->
 <%@ include file="../include/main_footer.jsp" %>
</div>
<!-- ./wrapper -->

<!-- REQUIRED JS SCRIPTS -->
<%@ include file="../include/plugin_js.jsp" %>

</body>
</html>