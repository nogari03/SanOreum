package project.admin.e_p006.controller;



import java.sql.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.springframework.web.bind.annotation.RequestParam;

public interface E_p006Controller {
	
	public JSONObject boardChart()throws Exception;
	public JSONObject searchDatePieChart( String startDate, String endDate, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public JSONObject selectPieChart( String key_word, String st, String end, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public JSONObject searchDateColumnChart( String startDate, String endDate, HttpServletRequest request, HttpServletResponse response) throws Exception;
	public JSONObject selectColumnChart( String key_word, String st, String end, HttpServletRequest request, HttpServletResponse response) throws Exception;

}
