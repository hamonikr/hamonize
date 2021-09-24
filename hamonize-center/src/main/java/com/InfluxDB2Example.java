// package com;

// import java.time.Instant;
// import java.util.List;

// import com.influxdb.annotations.Column;
// import com.influxdb.annotations.Measurement;
// import com.influxdb.client.InfluxDBClient;
// import com.influxdb.client.InfluxDBClientFactory;
// import com.influxdb.client.QueryApi;
// import com.influxdb.client.WriteApiBlocking;
// import com.influxdb.client.domain.WritePrecision;
// import com.influxdb.client.write.Point;
// import com.influxdb.query.FluxRecord;
// import com.influxdb.query.FluxTable;
// import org.springframework.boot.context.properties.EnableConfigurationProperties;

// @EnableConfigurationProperties(InfluxDBPropertiesCustom.class)
// public class InfluxDB2Example {
//     private static char[] token =
//             "-bkGS23j4EYS01V3Ov8vt9x9PFx37QZnjET3S3Vq7n1ciIwgj771BpAB8HCAiY_YRn_RqFcFGhlcQZ0tHh7Wrg=="
//                     .toCharArray();
//     private static String org = "hamonize";
//     private static String bucket = "invesume";

//     public static void main(final String[] args) {

//         InfluxDBClient influxDBClient =
//                 InfluxDBClientFactory.create("http://192.168.0.76:8086", token, org, bucket);

//         //
//         // Write data
//         //
//         // WriteApiBlocking writeApi = influxDBClient.getWriteApiBlocking();

//         //
//         // Write by Data Point
//         //
//         // Point point = Point.measurement("temperature").addTag("location", "west")
//         // .addField("value", 55D).time(Instant.now().toEpochMilli(), WritePrecision.MS);

//         // writeApi.writePoint(point);

//         //
//         // Write by LineProtocol
//         //
//         // writeApi.writeRecord(WritePrecision.NS, "temperature,location=north value=60.0");

//         //
//         // Write by POJO
//         //
//         Temperature temperature = new Temperature();
//         temperature.location = "south";
//         temperature.value = 62D;
//         temperature.time = Instant.now();

//         // writeApi.writeMeasurement(WritePrecision.NS, temperature);

//         //
//         // Query data
//         //
//         String flux =
//                 "from(bucket:\"invesume\") |> range(start: -30d) |> filter(fn: (r) => r[\"_measurement\"] == \"cpu\") |> filter(fn: (r) => r[\"_field\"] == \"usage_user\")"
//                         + "|> filter(fn: (r) => r[\"cpu\"] == \"cpu-total\")"
//                         + "|> group(columns: [\"uuid\"] ) |> top(n: 1) |> yield(name: \"mean\")";

//         QueryApi queryApi = influxDBClient.getQueryApi();

//         List<FluxTable> tables = queryApi.query(flux);
//         for (FluxTable fluxTable : tables) {
//             List<FluxRecord> records = fluxTable.getRecords();
//             for (FluxRecord fluxRecord : records) {
//                 System.out.println(fluxRecord.getTime() + ": " + fluxRecord.getValueByKey("_value")
//                         + ": " + fluxRecord.getValueByKey("uuid"));
//             }
//         }

//         influxDBClient.close();
//     }

//     @Measurement(name = "temperature")
//     private static class Temperature {

//         @Column(tag = true)
//         String location;

//         @Column
//         Double value;

//         @Column(timestamp = true)
//         Instant time;
//     }
// }
