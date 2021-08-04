package com.service;

import java.util.List;
import org.influxdb.dto.BoundParameterQuery.QueryBuilder;
import org.influxdb.dto.Point;
import org.influxdb.dto.Query;
import org.influxdb.dto.QueryResult;
import org.influxdb.impl.InfluxDBResultMapper;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.influxdb.InfluxDBTemplate;
import org.springframework.stereotype.Service;

import com.model.PcDataVo;




@Service
public class PcService {
	
	@Autowired
	private InfluxDBTemplate<Point> influxDBTemplate;
	
	
	public List<PcDataVo> list() {
		JSONArray jsonArray = new JSONArray();
		Object jObj = null;
		
		Query query = QueryBuilder.newQuery("SELECT * FROM cpu_value LIMIT 10")
		        .forDatabase("collectd")
		        .create();



		QueryResult queryResultCpu = influxDBTemplate.query(query);		
		InfluxDBResultMapper resultMapper = new InfluxDBResultMapper(); // thread-safe - can be reused
		JSONParser parser = new JSONParser();
		
		String str = queryResultCpu.toString();
		str = str.replace("QueryResult [results=[Result [series=[Series [", "{").split("]]]],")[0] + "]]}";
		
		try {
			jObj = parser.parse(str);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		jsonArray.add(jObj);
		
		return resultMapper.toPOJO(queryResultCpu, PcDataVo.class);
	}
}