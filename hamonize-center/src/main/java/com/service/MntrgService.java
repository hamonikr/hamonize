package com.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.influxdb.dto.BoundParameterQuery.QueryBuilder;
import org.influxdb.dto.BoundParameterQuery;
import org.influxdb.dto.Point;
import org.influxdb.dto.Query;
import org.influxdb.dto.QueryResult;
import org.influxdb.impl.InfluxDBResultMapper;
import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.influxdb.InfluxDBTemplate;
import org.springframework.stereotype.Service;
import com.mapper.IPcMangrMapper;
import com.model.CpuDataVo;
import com.model.PcDataVo;
import com.model.PcMangrVo;

@Service
public class MntrgService {

	@Autowired
	private InfluxDBTemplate<Point> influxDBTemplate;

	@Autowired
	private IPcMangrMapper pcMangrMapper;

	public List<PcMangrVo> pcMntrgList(PcMangrVo pvo) {

		List<PcMangrVo> pcAllList = pcMangrMapper.pcMntrngListInfo(pvo);
		List<PcDataVo> influxListData = influxInfo();

		if (pcAllList.size() > 0) {

			for (int i = 0; i < pcAllList.size(); i++) {
				String centerSgbUUID = pcAllList.get(i).getPc_uuid() + "";

				for (int j = 0; j < influxListData.size(); j++) {
					if (centerSgbUUID.matches(influxListData.get(j).getHost() + ".*")) {
						influxListData.get(j).setStatus(true);
						pcAllList.get(i).setPc_status("true");
					} else {
						influxListData.get(j).setStatus(false);
					} // end if
				}
			} // end for
		} else {
			influxListData.clear();
		}

		return pcAllList;
	}

	public List<PcDataVo> influxInfo() {

		JSONArray jsonArray = new JSONArray();
		Object jObj = null;

		Query cpu_query = QueryBuilder.newQuery(
				"SELECT value, host FROM (SELECT TOP(value, 1) AS value, host from cpu_value WHERE time > now() -1m GROUP BY host) tz('Asia/Seoul')")
				.forDatabase("collectd").create();

		InfluxDBResultMapper resultMapper = new InfluxDBResultMapper();
		long start = System.currentTimeMillis();
		QueryResult queryResult = influxDBTemplate.query(cpu_query);

		List<PcDataVo> memoryPointList = resultMapper.toPOJO(queryResult, PcDataVo.class);
		long end = System.currentTimeMillis();

		return memoryPointList;
	}

	public List<PcDataVo> getMemory(String host) {

		JSONArray jsonArray = new JSONArray();
		Object jObj = null;
//		Query mem_query = QueryBuilder.newQuery(
//						"SELECT value, host FROM memory_value where type='percent'and type_instance='used' and host='host' order by time desc limit 1")
//				.forDatabase("collectd").create();

		String s = "SELECT value, host , type_instance FROM memory_value where type='percent' and time > now() -20s and host=$host order by time desc limit 6";
		Query mem_query = BoundParameterQuery.QueryBuilder.newQuery(s).bind("host", host).forDatabase("collectd")
				.create();

		QueryResult results = influxDBTemplate.query(mem_query);
		InfluxDBResultMapper resultMapper = new InfluxDBResultMapper();

		QueryResult queryResult = influxDBTemplate.query(mem_query);

		List<PcDataVo> memoryPointList = resultMapper.toPOJO(queryResult, PcDataVo.class);

		return memoryPointList;
	}

	public void pcMntrgList2(PcMangrVo pvo) {

		List<PcMangrVo> pcAllList = pcMangrMapper.pcMntrngListInfo(pvo);
		CpuDataVo cpuVo = new CpuDataVo();
		List<String> strList = new ArrayList<String>();

		ArrayList<HashMap<String, String>> influxDatalist = new ArrayList<HashMap<String, String>>();
		HashMap<String, String> influxMap = new HashMap<String, String>();

		QueryResult.Series tmpInfluxData = null;
		for (int i = 0; i < pcAllList.size(); i++) {
			String tmpHostNm = pcAllList.get(i).getDept_seq() + "";

			tmpInfluxData = influxInfo2(tmpHostNm);
			/*
			 * if( tmpInfluxData != null ){ // 데이터 비교 처리 for( Object influxDataVal :
			 * tmpInfluxData.getValues().get(i) ){ if(tmpHostNm.equals(influxDataVal)){
			 * tmpInfluxData.getValues().get(i).add( "true"); }else{
			 * tmpInfluxData.getValues().get(i).add("false"); } } }
			 */
		}

	}

	public QueryResult.Series influxInfo2(String hostName) {

		JSONArray jsonArray = new JSONArray();
		Object jObj = null;
		Query cpu_query = QueryBuilder.newQuery(
				"SELECT value, host FROM (SELECT TOP(value, 1) AS value, host from cpu_value WHERE time > now() -1m GROUP BY host) tz('Asia/Seoul')")
				.forDatabase("collectd").bind("host", hostName).create();

		QueryResult queryResult = influxDBTemplate.query(cpu_query);
		QueryResult.Result retQueryResult = null;
		QueryResult.Series retQuerySeries = null;

		for (QueryResult.Result result : queryResult.getResults()) {

			if (result.getSeries() != null) {
				retQueryResult = queryResult.getResults().get(0);
				retQuerySeries = retQueryResult.getSeries().get(0);

			}

		}

		return retQuerySeries;
	}

	public QueryResult.Series influxInfo2() {

		JSONArray jsonArray = new JSONArray();
		Object jObj = null;
		Query cpu_query = QueryBuilder.newQuery(
				"SELECT time, value FROM cpu_value where host = $host and time >= now() - 10s order by time desc LIMIT 1")
				.forDatabase("collectd").bind("host", "localhost")
//		        .bind("host", "inv.ivs.ad.com")
				.create();

		QueryResult queryResult = influxDBTemplate.query(cpu_query);
		for (QueryResult.Result result : queryResult.getResults()) {

			for (QueryResult.Series series : result.getSeries()) {
			}
		}

		QueryResult.Result retQueryResult = queryResult.getResults().get(0);
		QueryResult.Series retQuerySeries = retQueryResult.getSeries().get(0);

		return retQuerySeries;
	}

	public List<PcDataVo> list() {
		JSONArray jsonArray = new JSONArray();
		Object jObj = null;

		Query cpu_query = QueryBuilder.newQuery(
				"SELECT value, host FROM (SELECT TOP(value, 1) AS value, host from cpu_value WHERE time > now() -1m GROUP BY host) tz('Asia/Seoul')")
				.forDatabase("collectd").create();
		QueryResult results = influxDBTemplate.query(cpu_query);
		InfluxDBResultMapper resultMapper = new InfluxDBResultMapper(); // thread-safe - can be reused
		QueryResult queryResult = influxDBTemplate.query(cpu_query);

		for (QueryResult.Result result : queryResult.getResults()) {

			for (QueryResult.Series series : result.getSeries()) {
			}
		}
		List<PcDataVo> memoryPointList = resultMapper.toPOJO(queryResult, PcDataVo.class);

		return null;

	}
}