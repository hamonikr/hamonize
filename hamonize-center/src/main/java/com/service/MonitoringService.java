package com.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.mapper.IMonitoringMapper;
import com.model.PcDataVo;
import com.model.PcMemoryDataVo;

import org.influxdb.dto.BoundParameterQuery.QueryBuilder;
import org.influxdb.dto.Point;
import org.influxdb.dto.Query;
import org.influxdb.dto.QueryResult;
import org.influxdb.impl.InfluxDBResultMapper;
import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.influxdb.InfluxDBTemplate;
import org.springframework.stereotype.Service;

@Service
public class MonitoringService {

	@Autowired
	private IMonitoringMapper mMpper;

	@Autowired
	private InfluxDBTemplate<Point> influxDBTemplate;

	public List<Map<String, Object>> pcListInfo(Map<String, Object> params) {

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = mMpper.pcListInfo(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<PcDataVo> influxInfo() {
		JSONArray jsonArray = new JSONArray();
		Object jObj = null;

		Query cpu_query = QueryBuilder.newQuery(
			"SELECT value, host FROM (SELECT TOP(value, 1) AS value, host from cpu_value WHERE time > now() -1m GROUP BY host) tz('Asia/Seoul')")
			.forDatabase("telegraf").create();
			
		InfluxDBResultMapper resultMapper = new InfluxDBResultMapper();
		long start = System.currentTimeMillis();
		System.out.println("startTime===="+start);
		QueryResult queryResult = influxDBTemplate.query(cpu_query);
		//for (QueryResult.Result result : queryResult.getResults()) {

			// print details of the entire result
			//System.out.println(result.toString());

			// iterate the series within the result
			/*
			 * for (QueryResult.Series series : result.getSeries()) {
			 * System.out.println("series.getName() = " + series.getName());
			 * System.out.println("series.getColumns() = " + series.getColumns());
			 * System.out.println("series.getValues() = " + series.getValues());
			 * System.out.println("series.getTags() = " + series.getTags()); }
			 */
		//}

//		System.out.println("results=======" + results.getResults());

		List<PcDataVo> memoryPointList = resultMapper.toPOJO(queryResult, PcDataVo.class);
		long end = System.currentTimeMillis();
		System.out.println("spendtime===="+(end-start));
//		System.out.println("11111========" + memoryPointList);
//		System.out.println("11111========" + memoryPointList.get(0).getHost());

		return memoryPointList;
	}

	/*
	 * public void insertMemory(){
	 * 
	 * 
	 * Query mem_query = QueryBuilder.newQuery(
	 * "insert memory_value,host='HamoniKR-03000200-0400-0500-0006-0007000080009' type='percent' type_instance='dd' value='32'"
	 * ) .forDatabase("telegraf").create();
	 * 
	 * String[] aa = {"used","buffered","cached","free","slab_recl","slab_unrecl"};
	 * for(int j = 0; j < 15000000;j++) { for(int i=0;i<aa.length;i++) { Point point
	 * = Point.measurement("memory_value") .time(System.currentTimeMillis(),
	 * TimeUnit.MILLISECONDS) .addField("host",
	 * "HamoniKR-03000200-0400-0500-0006-0007000080009") .addField("type",
	 * "percent") .addField("type_instance", aa[i]) .addField("value", 32F)
	 * .build(); influxDBTemplate.write(point); System.out.println("i====="+i); }
	 * System.out.println("j====="+j); } System.out.println("끝"); }
	 */

	public List<PcMemoryDataVo> getMemory(String host) {

		JSONArray jsonArray = new JSONArray();
		Object jObj = null;

		/*
		 * Query cpu_query = QueryBuilder .newQuery(
		 * "SELECT value, host FROM (SELECT TOP(value, 1) AS value, host from cpu_value WHERE time > now() -1m GROUP BY host) tz('Asia/Seoul')"
		 * ) .forDatabase("telegraf").create();
		 */

		Query mem_query = QueryBuilder
				.newQuery("SELECT value, host , type_instance FROM memory_value where type='percent' and time > now() -20s and host='" + host
						+ "' order by time desc limit 6")
				.forDatabase("telegraf").create();
		QueryResult results = influxDBTemplate.query(mem_query);
		InfluxDBResultMapper resultMapper = new InfluxDBResultMapper();

		QueryResult queryResult = influxDBTemplate.query(mem_query);
		int i = 0;
		for (QueryResult.Result result : queryResult.getResults()) {

			// print details of the entire result
			//System.out.println(result.toString());
			//System.out.println("111==========" + result.getSeries().get(i));
			//System.out.println("222==========" + result.getSeries().get(i).getValues());
			i++;
			// iterate the series within the result
			/*
			 * for (QueryResult.Series series : result.getSeries()) {
			 * System.out.println("series.getName() = " + series.getName());
			 * System.out.println("series.getColumns() = " + series.getColumns());
			 * System.out.println("series.getValues() = " + series.getValues());
			 * System.out.println("series.getTags() = " + series.getTags()); }
			 */
		}

//		System.out.println("results=======" + results.getResults());

		List<PcMemoryDataVo> memoryPointList = resultMapper.toPOJO(queryResult, PcMemoryDataVo.class);

//		System.out.println("11111========" + memoryPointList);
//		System.out.println("11111========" + memoryPointList.get(0).getHost());

		return memoryPointList;
	}
	
	
	public List<PcDataVo> getCpu(String host) {

		JSONArray jsonArray = new JSONArray();
		Object jObj = null;

		/*
		 * Query cpu_query = QueryBuilder .newQuery(
		 * "SELECT value, host FROM (SELECT TOP(value, 1) AS value, host from cpu_value WHERE time > now() -1m GROUP BY host) tz('Asia/Seoul')"
		 * ) .forDatabase("telegraf").create();
		 */

		Query cpu_query = QueryBuilder
				.newQuery("SELECT ROUND(mean(value)) as value FROM cpu_value WHERE type_instance = 'user' AND type = 'percent' and time > now() -20s and host='"+host+ "'"
						+ "order by time desc")
				.forDatabase("telegraf").create();
		QueryResult results = influxDBTemplate.query(cpu_query);
		InfluxDBResultMapper resultMapper = new InfluxDBResultMapper();

		QueryResult queryResult = influxDBTemplate.query(cpu_query);
		int i = 0;
		for (QueryResult.Result result : queryResult.getResults()) {

			// print details of the entire result
			//System.out.println(result.toString());
			//System.out.println("111==========" + result.getSeries().get(i));
			//System.out.println("222==========" + result.getSeries().get(i).getValues());
			i++;
			// iterate the series within the result
			/*
			 * for (QueryResult.Series series : result.getSeries()) {
			 * System.out.println("series.getName() = " + series.getName());
			 * System.out.println("series.getColumns() = " + series.getColumns());
			 * System.out.println("series.getValues() = " + series.getValues());
			 * System.out.println("series.getTags() = " + series.getTags()); }
			 */
		}

//		System.out.println("results=======" + results.getResults());

		List<PcDataVo> cpuPointList = resultMapper.toPOJO(queryResult, PcDataVo.class);

//		System.out.println("11111========" + memoryPointList);
//		System.out.println("11111========" + memoryPointList.get(0).getHost());

		return cpuPointList;
	}

}
