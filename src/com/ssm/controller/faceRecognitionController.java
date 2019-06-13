package com.ssm.controller;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.ssm.model.FaceV3DetectBean;
import com.ssm.utils.FaceSpot;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


/**
 * 人脸识别服务 controller
 * @author liyingming
 *
 */
@Controller
@RequestMapping(value = "/faceRecognition")
public class faceRecognitionController {

	 /**
	 * 人脸检测测试页面
	 * @return
	 * @throws Exception  
	 */
    @RequestMapping(value = "/test.do")
    public ModelAndView queryVoi() throws Exception {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("/artificialIntelligence/faceRecognition/test");
        return modelAndView;
    }
	
    /**
   	 * 请求人脸检测
   	 * @return
   	 * @throws Exception  
   	 */
	@RequestMapping(value = "/save.do")
	@ResponseBody
	public Map<String, Object> queryService(@RequestParam("the_file") MultipartFile file) {
		Map<String, Object> modelMap = new HashMap<String, Object>();
		try {
			//将数据转为流
			InputStream content = file.getInputStream();
			ByteArrayOutputStream swapStream = new ByteArrayOutputStream();  
	        byte[] buff = new byte[100];  
	        int rc = 0;  
	        while ((rc = content.read(buff, 0, 100)) > 0) {  
	            swapStream.write(buff, 0, rc);  
	        }  
	        //获得二进制数组
	        byte[] in2b = swapStream.toByteArray(); 
	        //调用人脸检测的方法
	        String  str = FaceSpot.detectFace(in2b,""+1);
	        JSONObject job = new JSONObject(FaceSpot.faceverify(in2b));
			 System.out.println(job.toString());
			 JSONObject testData = job.getJSONObject("result");
			 //System.out.println(testData.get("face_liveness"));
	        
	        JSON json = JSON.parseObject(str);
            FaceV3DetectBean bean = JSON.toJavaObject(json, FaceV3DetectBean.class);
            JSONArray arr = new JSONArray();
            
	     	 for(int i=0;i<bean.getResult().getFace_list().size();i++){
			        JSONObject jsonObject = new JSONObject();
			    	//获取年龄
			        int ageOne = bean.getResult().getFace_list().get(i).getAge();
			     	//处理年龄
			        String age =String.valueOf(new BigDecimal(ageOne).setScale(0, BigDecimal.ROUND_HALF_UP));
			        jsonObject.put("age", age);
					
					//获取美丑打分
			        Double beautyOne = (Double) bean.getResult().getFace_list().get(i).getBeauty();
					//处理美丑打分
			     	String beauty =String.valueOf(new BigDecimal(beautyOne).setScale(0, BigDecimal.ROUND_HALF_UP));
			     	jsonObject.put("beauty", beauty);
					
					//获取性别  male(男)、female(女)
					String gender = (String) bean.getResult().getFace_list().get(i).getGender().getType();
					jsonObject.put("gender", gender);
					
					//获取是否带眼睛 0-无眼镜，1-普通眼镜，2-墨镜
					String glasses =  bean.getResult().getFace_list().get(i).getGlasses().getType();
					jsonObject.put("glasses", String.valueOf(glasses));
					
					//获取是否微笑，0，不笑；1，微笑；2，大笑
					String expression =  bean.getResult().getFace_list().get(i).getExpression().getType();
					jsonObject.put("expression", String.valueOf(expression));
					arr.put(jsonObject);
			 }
			modelMap.put("strjson", arr.toString());
			modelMap.put("face_liveness", testData.get("face_liveness"));
			modelMap.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			modelMap.put("success", false);
			modelMap.put("data", e.getMessage());
		}
		return modelMap;
	}
	
	
}
