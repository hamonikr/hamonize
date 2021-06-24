package com.service;

import java.sql.ResultSet;
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
		//log.info(" ---- svc : list");
		JSONArray jsonArray = new JSONArray();
		Object jObj = null;

		
		Query query = QueryBuilder.newQuery("SELECT * FROM cpu_value LIMIT 10")
		        .forDatabase("collectd")
		        .create();

		/*
		memory_value
		disk_io_time
		interface_rx
		interface_tx
		*/



		QueryResult queryResultCpu = influxDBTemplate.query(query);
		
		InfluxDBResultMapper resultMapper = new InfluxDBResultMapper(); // thread-safe - can be reused

		//log.info(" ------ queryResultCpu : " + queryResultCpu);
//		log.info(" ------ queryResultMemory_value : " + queryResultMemory_value);
//		log.info(" ------ queryResultDisk_io : " + queryResultDisk_io);
//		log.info(" ------ queryResultInterface_rx_query : " + queryResultInterface_rx_query);
//		log.info(" ------ queryResultInterface_tx_query : " + queryResultInterface_tx_query);

		//log.info(" ------ ------------------------------------------------------------------------");
		
		//log.info(" ------ queryResultCpu : " + (queryResultCpu.toString()));
		
		//log.info(" ------ resultMapper.toPOJO(queryResultCpu, PcData.class) : " + resultMapper.toPOJO(queryResultCpu, PcDataVo.class));
		
		/*
		[results=
			[Result 
				[series=
					[Series 
						[name=cpu_value, 
							tags=null, 
							columns=[time, host, instance, type, type_instance, value], 
							values=[
								[2019-05-07T14:03:30.60357Z, localhost, 0, cpu, user, 23330.0], 
								[2019-05-07T14:03:30.603601Z, localhost, 1, cpu, user, 22107.0], 
								[2019-05-07T14:03:30.603714Z, localhost, 2, cpu, user, 23011.0], 
								[2019-05-07T14:03:30.603735Z, localhost, 3, cpu, user, 23275.0], 
								[2019-05-07T14:03:30.603748Z, localhost, 0, cpu, system, 5430.0], 
								[2019-05-07T14:03:30.603917Z, localhost, 1, cpu, system, 5635.0], 
								[2019-05-07T14:03:30.603922Z, localhost, 2, cpu, system, 5491.0], 
								[2019-05-07T14:03:30.603926Z, localhost, 3, cpu, system, 5504.0], 
								[2019-05-07T14:03:30.60393Z, localhost, 0, cpu, wait, 572.0], 
								[2019-05-07T14:03:30.603933Z, localhost, 1, cpu, wait, 219.0]
							]
							]
							], error=null]], error=null]
		
		
		
		[name:cpu_value, tags:null, columns:[time, host, instance, type, type_instance, value], values:[[2019-05-07T14:03:30.60357Z, localhost, 0, cpu, user, 23330.0], [2019-05-07T14:03:30.603601Z, localhost, 1, cpu, user, 22107.0], [2019-05-07T14:03:30.603714Z, localhost, 2, cpu, user, 23011.0], [2019-05-07T14:03:30.603735Z, localhost, 3, cpu, user, 23275.0], [2019-05-07T14:03:30.603748Z, localhost, 0, cpu, system, 5430.0], [2019-05-07T14:03:30.603917Z, localhost, 1, cpu, system, 5635.0], [2019-05-07T14:03:30.603922Z, localhost, 2, cpu, system, 5491.0], [2019-05-07T14:03:30.603926Z, localhost, 3, cpu, system, 5504.0], [2019-05-07T14:03:30.60393Z, localhost, 0, cpu, wait, 572.0], [2019-05-07T14:03:30.603933Z, localhost, 1, cpu, wait, 219.0
		[
			name:cpu_value, 
			tags:null, 
			columns:[time, host, instance, type, type_instance, value], 
			values:[
				[2019-05-07T14:03:30.60357Z, localhost, 0, cpu, user, 23330.0], 
				[2019-05-07T14:03:30.603601Z, localhost, 1, cpu, user, 22107.0], 
				[2019-05-07T14:03:30.603714Z, localhost, 2, cpu, user, 23011.0], 
				[2019-05-07T14:03:30.603735Z, localhost, 3, cpu, user, 23275.0], 
				[2019-05-07T14:03:30.603748Z, localhost, 0, cpu, system, 5430.0], 
				[2019-05-07T14:03:30.603917Z, localhost, 1, cpu, system, 5635.0], 
				[2019-05-07T14:03:30.603922Z, localhost, 2, cpu, system, 5491.0], 
				[2019-05-07T14:03:30.603926Z, localhost, 3, cpu, system, 5504.0], 
				[2019-05-07T14:03:30.60393Z, localhost, 0, cpu, wait, 572.0], 
				[2019-05-07T14:03:30.603933Z, localhost, 1, cpu, wait, 219.0]
			]
		]
		
		
		*/
		
		JSONParser parser = new JSONParser();
		
		String str = queryResultCpu.toString();
		str = str.replace("QueryResult [results=[Result [series=[Series [", "{").split("]]]],")[0] + "]]}";
		
//		str = str.replaceAll("=", "\":\"").replaceAll("[", "\"\\[").replaceAll("],", "\"\\],");
//		str = str.replaceAll("=", "\":\"").replaceAll(", ", "\", \"");
		
		//log.info(" ------ str : " + str);
		
		try {
			jObj = parser.parse(str);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		jsonArray.add(jObj);
		
		//log.info(" ------ svc : groupList - obj : " + jsonArray);
		
		return resultMapper.toPOJO(queryResultCpu, PcDataVo.class);
	}
}