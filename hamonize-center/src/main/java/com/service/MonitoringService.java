package com.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.influxdb.client.InfluxDBClient;
import com.influxdb.client.InfluxDBClientFactory;
import com.influxdb.client.QueryApi;
import com.influxdb.query.FluxRecord;
import com.influxdb.query.FluxTable;
import com.mapper.IMonitoringMapper;
import com.model.PcDataVo;
import com.model.PcMemoryDataVo;

import org.influxdb.dto.BoundParameterQuery.QueryBuilder;
import org.influxdb.dto.Point;
import org.influxdb.dto.Query;
import org.influxdb.dto.QueryResult;
import org.influxdb.impl.InfluxDBResultMapper;
import org.json.simple.JSONArray;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.influxdb.InfluxDBTemplate;
import org.springframework.stereotype.Service;

@Service
public class MonitoringService {

	@Autowired
	private IMonitoringMapper mMpper;

	@Autowired
	private InfluxDBTemplate<Point> influxDBTemplate;
	private Logger logger = LoggerFactory.getLogger(this.getClass());

	public List<Map<String, Object>> pcListInfo(Map<String, Object> params) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		List<FluxRecord> influxList = influxInfo();
		try {
			list = mMpper.pcListInfo(params);
			for (int i = 0; i < list.size(); i++) {

				for (int y = 0; y < influxList.size(); y++) {
					if (list.get(i).get("pc_uuid").toString().trim()
							.equals(influxList.get(y).getValueByKey("uuid").toString().trim())) {
						list.get(i).put("pc_status", "true");
					}
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return list;
	}

	// public List<PcDataVo> influxInfo() {
	// JSONArray jsonArray = new JSONArray();
	// Object jObj = null;

	// Query cpu_query = QueryBuilder.newQuery(
	// "SELECT TOP(value, 1) AS value, host from cpu_value WHERE time > now() - 20s and host !=
	// 'localhost' GROUP BY host")
	// .forDatabase("collectd").create();
	// InfluxDBResultMapper resultMapper = new InfluxDBResultMapper();
	// long start = System.currentTimeMillis();
	// QueryResult queryResult = influxDBTemplate.query(cpu_query);
	// List<PcDataVo> memoryPointList = resultMapper.toPOJO(queryResult, PcDataVo.class);
	// long end = System.currentTimeMillis();
	// return memoryPointList;
	// }
	public List<FluxRecord> influxInfo() {
		char[] token =
				"mytoken"
						.toCharArray();
		String org = "myorgname";
		String bucket = "mybucketname";

		InfluxDBClient influxDBClient =
				InfluxDBClientFactory.create("http://ts.hamonikr.org:8086", token, org, bucket);

		String flux =
				"from(bucket:\"mybucketname\") |> range(start: -1m) |> filter(fn: (r) => r[\"_measurement\"] == \"cpu\") |> filter(fn: (r) => r[\"_field\"] == \"usage_user\")"
						+ "|> filter(fn: (r) => r[\"cpu\"] == \"cpu-total\")"
						+ "|> group(columns: [\"uuid\"] ) |> top(n: 1) |> yield(name: \"mean\")";

		QueryApi queryApi = influxDBClient.getQueryApi();

		List<FluxTable> tables = queryApi.query(flux);
		List<FluxRecord> list = new ArrayList<FluxRecord>();
		for (FluxTable fluxTable : tables) {
			List<FluxRecord> records = fluxTable.getRecords();
			for (FluxRecord fluxRecord : records) {
				list.add(fluxRecord);
				// System.out.println(fluxRecord.getTime() + ": " + fluxRecord.getValueByKey("_value")
				// 		+ ": " + fluxRecord.getValueByKey("uuid"));
			}
		}

		influxDBClient.close();
		return list;
	}


	public List<PcMemoryDataVo> getMemory(String host) {

		JSONArray jsonArray = new JSONArray();
		Object jObj = null;

		Query mem_query = QueryBuilder.newQuery(
				"SELECT value, host , type_instance FROM memory_value where type='percent' and time > now() -20s and host='"
						+ host + "' order by time desc limit 6")
				.forDatabase("collectd").create();
		QueryResult results = influxDBTemplate.query(mem_query);
		InfluxDBResultMapper resultMapper = new InfluxDBResultMapper();

		QueryResult queryResult = influxDBTemplate.query(mem_query);
		int i = 0;


		List<PcMemoryDataVo> memoryPointList =
				resultMapper.toPOJO(queryResult, PcMemoryDataVo.class);

		return memoryPointList;
	}


	public List<PcDataVo> getCpu(String host) {

		JSONArray jsonArray = new JSONArray();
		Object jObj = null;

		Query cpu_query = QueryBuilder.newQuery(
				"SELECT ROUND(mean(value)) as value FROM cpu_value WHERE type_instance = 'user' AND type = 'percent' and time > now() -20s and host='"
						+ host + "'" + "order by time desc")
				.forDatabase("collectd").create();
		QueryResult results = influxDBTemplate.query(cpu_query);
		InfluxDBResultMapper resultMapper = new InfluxDBResultMapper();

		QueryResult queryResult = influxDBTemplate.query(cpu_query);
		int i = 0;

		List<PcDataVo> cpuPointList = resultMapper.toPOJO(queryResult, PcDataVo.class);

		return cpuPointList;
	}

}