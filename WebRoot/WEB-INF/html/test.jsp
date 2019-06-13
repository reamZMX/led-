<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">	
<title>人脸检测</title>
<script src="js/jquery-2.1.1.js" type="text/javascript" charset="utf-8"></script>
<script>

	//判断浏览器是否支持HTML5 Canvas
	window.onload = function () {
		try {
		//动态创建一个canvas元 ，并获取他2Dcontext。如果出现异常则表示不支持 document.createElement("canvas").getContext("2d");
		 document.getElementById("support").innerHTML = "浏览器支持HTML5 CANVAS";
		}
		catch (e) {
		 document.getElementByIdx("support").innerHTML = "浏览器不支持HTML5 CANVAS";
		}
	};
	
	//这段代 主要是获取摄像头的视频流并显示在Video 签中
	window.addEventListener("DOMContentLoaded", function () {
		var canvas = document.getElementById("canvas"),
		context = canvas.getContext("2d"),
		video = document.getElementById("video"),
		videoObj = { "video": true },
		errBack = function (error) {
			console.log("Video capture error: ", error.code);
		};
		//拍照按钮
// 		$("#snap").click(function () {
// 			context.drawImage(video, 0, 0, 330, 250);
// 			})
		//拍照每秒一次
		setInterval(function(){
			context.drawImage(video, 0, 0, 330, 250)
			CatchCode();
		},1000);
		//navigator.getUserMedia这个写法在Opera中好像是navigator.getUserMedianow
		//更新兼容火狐浏览器
		if (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia) {
			    navigator.getUserMedia=navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
			    navigator.getUserMedia(videoObj, function (stream) {
				video.srcObject  = stream;
				video.play();
				}, errBack);
		}
	
	}, false);
	
	function dataURItoBlob(base64Data) {
		var byteString;
		if (base64Data.split(',')[0].indexOf('base64') >= 0)
		byteString = atob(base64Data.split(',')[1]);
		else
		byteString = unescape(base64Data.split(',')[1]);
		var mimeString = base64Data.split(',')[0].split(':')[1].split(';')[0];
		var ia = new Uint8Array(byteString.length);
		for (var i = 0; i < byteString.length; i++) {
		ia[i] = byteString.charCodeAt(i);
		}
		return new Blob([ia], {type:mimeString});
	}
	
	//上传服务器
	function CatchCode() {
		var canvans = document.getElementById("canvas");
		//获取浏览器页面的画布对象
		//以下开始编 数据
		var imageBase64 = canvans.toDataURL();
		var blob = dataURItoBlob(imageBase64);  // 上一步中的函数
		var fd = new FormData(document.forms[0]);
		fd.append("the_file", blob, 'image.png');
		//将图像转换为base64数据
		$.ajax({
	   		type:"POST",
	   		url:"faceRecognition/save.do",
	   		processData: false,     // 必须
	      	contentType: false,     // 必须
	      	data:fd,
	    	datatype: "json",
	   		success:function(data){
		   		var mes = eval(data);
		   		//alert(mes.success);
		   		//var jsonObj =   $.parseJSON(mes.strjson); 
		   		//alert(jsonObj[0].age);
		   		if (mes.success) {
 		   			//alert(mes.strjson);
		   			var jsonObj =  $.parseJSON(mes.strjson); 
		   			//alert(jsonObj);
		   			var age = jsonObj[0].age;
 		   			
		   			var beauty = jsonObj[0].beauty;
		   			var gendergender = jsonObj[0].gender;
		   			var glasses = jsonObj[0].glasses;
		   			var expression = jsonObj[0].expression
		   			
		   			$("#age").html(age);
		   			$("#beauty").html(beauty);
		   			$("#faceverify").html(mes.face_liveness);
		   			
		   			if(gendergender == 'male'){
		   				$("#gendergender").html("男");
		   			}else{
		   				$("#gendergender").html("女");
		   			}
		   			
		   			if(glasses == 'none'){
		   				$("#glasses").html("未戴眼镜");
		   			}else if(glasses == 'common'){
		   				$("#glasses").html("戴了普通眼镜");
		   			}else{
		   				$("#glasses").html("戴了墨镜");
		   			}
					
		   			if(expression == 'none'){
		   				$("#expression").html("不笑");
		   			}else if(expression == 'smile'){
		   				$("#expression").html("微笑");
		   			}else{
		   				$("#expression").html("大笑");
		   			}
		   		}
	   		},
	   		error: function(){
	    		//请求出错处理
	    		alert("出情况了");
	    		}         
	  		});
	}
</script>
<style> 
.div-a{ float:left;width:60%;height:60%;border:1px solid #F00} 
.div-b{ float:left;width:39%;height:60%;border:1px solid #000} 
span{ font-size:25px }
</style> 
</head> 
<body> 
	<!-- 左边区域 -->
	<div class="div-a" id="contentHolder">
			<video id="video" width="100%" height="60%" autoplay></video>
			<canvas style="" hidden="hidden"  id="canvas" width="520" height="250"></canvas>
	</div> 
	<!-- 右边区域 -->
	<div class="div-b" >
			<!-- 测试按钮 -->
<!-- 		<input type="button" id="snap" style="width:100px;height:35px;" value="拍 照" /> -->
<!-- 		<input type="button" onclick="CatchCode();" style="width:100px;height:35px;" value="上传服务器" /> -->
		
		<h1>人脸检测实时数据</h1>
		<span>年龄：</span><span id="age"></span><br/>
		<span>颜值：</span><span id="beauty" ></span><br/>
		<span>性别：</span><span id="gendergender"></span><br/>
		<span>是否戴眼镜:</span><span id="glasses"></span><br/>
		<span>表情：</span><span id="expression"></span><br/>
		<span>活体分数：</span><span id="faceverify"></span><br/>
	</div> 
		
	</body>
</html>