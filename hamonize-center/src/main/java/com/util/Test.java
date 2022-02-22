package com.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import org.apache.http.entity.ContentType;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClient.RequestBodySpec;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.util.LinkedMultiValueMap;

@RestController
@RequestMapping(value="test")
public class Test {

    // public static void main(String agrs[]){

    //   WebClient wc = WebClient.builder().baseUrl("http://192.168.0.212").build();

    //   try {
    //     //ResponseEntity<JSONArray> response = wc.get().uri(uri -> uri.pathSegment("/api/v2/inventories/","{id}")
    //     ResponseEntity<JSONArray> response = wc.get().uri("/api/v2/inventories/{id}",1)
    //     .accept(MediaType.APPLICATION_JSON)
    //     .retrieve()
    //     .toEntity(JSONArray.class).block();
    //     System.out.println("response====="+response);
    //   } catch (Exception e) {
    //     //TODO: handle exception
    //   }
    // }

    @RequestMapping(value="test1")
    public String getInventoryList(){

      WebClient wc = WebClient.builder()
      .defaultHeaders(header -> header.setBasicAuth("admin","password"))
      .baseUrl("http://192.168.0.220").build();
      
      try {
        System.out.println("11111111111111111111111111111111");
        Mono<String> response = wc.get().uri(UriBuilder -> UriBuilder
        .path("/api/v2/inventories/").path("{id}/").path("inventory_sources/")
        //.queryParam("--user", "admin:password")
        //.queryParam("password", "password")
        .build(3))
        .exchange().flatMap(clientResponse -> {
          if (clientResponse.statusCode().is5xxServerError()) {
              clientResponse.body((clientHttpResponse, context) -> {
                  return clientHttpResponse.getBody();
              });
              return clientResponse.bodyToMono(String.class);
          }
          else
              return clientResponse.bodyToMono(String.class);
      });
        //.accept(MediaType.APPLICATION_JSON)
        //.retrieve()
        //.bodyToMono(String.class);
        // Mono<String> response = wc.get() 
        // .uri("/api/v2/inventories/")
        // .retrieve()
        // .bodyToMono(String.class);    

        String objects = response.block();
        return objects.toString();
      } catch (Exception e) {
        //TODO: handle exception
      }
      return null;
  
    }

    @RequestMapping(value="test6")
    public String getStdout(){

      WebClient wc = WebClient.builder()
      .defaultHeaders(header -> header.setBasicAuth("admin","password"))
      .baseUrl("http://192.168.0.220").build();
      
      try {
        System.out.println("11111111111111111111111111111111");
        Mono<String> response = wc.get().uri(UriBuilder -> UriBuilder
        //.path("/api/v2/ad_hoc_command_events/").path("{id}/")
        .path("/api/v2/ad_hoc_commands/").path("{id}/").path("events/")
        //.queryParam("--user", "admin:password")
        //.queryParam("password", "password")
        .build(389))
        .exchange().flatMap(clientResponse -> {
          if (clientResponse.statusCode().is5xxServerError()) {
              clientResponse.body((clientHttpResponse, context) -> {
                  return clientHttpResponse.getBody();
              });
              return clientResponse.bodyToMono(String.class);
          }
          else
              return clientResponse.bodyToMono(String.class);
      });
        //.accept(MediaType.APPLICATION_JSON)
        //.retrieve()
        //.bodyToMono(String.class);
        // Mono<String> response = wc.get() 
        // .uri("/api/v2/inventories/")
        // .retrieve()
        // .bodyToMono(String.class);    

        String objects = response.block();
        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
        //System.out.println("jsonObj===="+jsonObj.toJSONString());
        
        JSONArray resultsArray = (JSONArray) jsonObj.get("results");
        JSONArray makeResultArray = new JSONArray();
        JSONObject okHostObj = new JSONObject();
        int index = 0;
        for(Object tmp : resultsArray){
          JSONObject summary_fieldsObj = new JSONObject();
          JSONObject event_dataObj = new JSONObject();
          summary_fieldsObj = (JSONObject) tmp;
          event_dataObj = (JSONObject) tmp;
          if(index == 0)
          {
            okHostObj = summary_fieldsObj;
          }
          summary_fieldsObj = (JSONObject) summary_fieldsObj.get("summary_fields");
          event_dataObj = (JSONObject) event_dataObj.get("event_data");
          // if(event_dataObj != null){
          //   event_dataObj = (JSONObject) event_dataObj.get("res");
          // }
          //event_dataObj = (JSONObject) event_dataObj.get("res");
          //event_dataObj = (JSONObject) event_dataObj.get("msg");
          //event_dataObj = (JSONObject) event_dataObj.get("res");
          //event_dataObj = (JSONObject) event_dataObj.get("msg");
          if(!summary_fieldsObj.isEmpty() && index > 0)
          {
            //JSONObject makeResultObj = (JSONObject) summary_fieldsObj.get("host");
            JSONObject makeResultObj = (JSONObject) tmp;
            //makeResultObj.put("event_dataObj", event_dataObj);
            //summary_fieldsObj.put("event_dataObj", event_dataObj);
            //System.out.println("makeResultObj========="+makeResultObj);
            makeResultArray.add(makeResultObj);
          }

          // if(!event_dataObj.isEmpty() && index > 0)
          //   event_dataArray.add(event_dataObj);
          
            index++;
        }
        JSONObject allHostObj = new JSONObject();
        index = 0;
        JSONArray finalResultArray = new JSONArray();
        for(Object tmp : makeResultArray){
          JSONObject finalResult = new JSONObject();
          //JSONObject stdout = new JSONObject();
          JSONObject host_uuid = new JSONObject();
          finalResult = (JSONObject) tmp;
          String stdout = finalResult.get("stdout").toString();
          System.out.println("finalResult.get().toString()==========="+!stdout.isEmpty());
          //if(finalResult.get("stdout").toString() != null)
          //stdout = (JSONObject) finalResult.get("stdout");
          host_uuid = (JSONObject) finalResult.get("summary_fields");
          host_uuid = (JSONObject) host_uuid.get("host");
          //host_uuid = (JSONObject) host_uuid.get("description");
          //event_dataObj = (JSONObject) host.get("event_dataObj");
          if(!stdout.isEmpty())
          {
            System.out.println("finalResult111==================="+finalResult);
            System.out.println("finalResult222==================="+finalResult.get("stdout"));
            System.out.println("host111111111=============="+host_uuid);
          }
          //event_dataObj = (JSONObject) event_dataObj.get("res");
          //System.out.println("host==========="+host);
          //System.out.println("event_dataObj==========="+event_dataObj);
          //host = (JSONObject) host.get("host");
          //res = (JSONObject) event_dataArray.get(index);
          // if(host.get("name") != null)
          // {
          // //allHostObj.put(host.get("name"),host.get("description"));
          // allHostObj.put(host.get("name"), host);
          // }
          index++;
        }
        System.out.println("allHostObj========="+allHostObj);
        // okHostObj = (JSONObject) okHostObj.get("event_data");
        // okHostObj = (JSONObject) okHostObj.get("ok");
        // Set<String> okHostSet = new HashSet<>(okHostObj.keySet());
        // Set<String> allHostSet = new HashSet<>(allHostObj.keySet());
        // ArrayList<String> okHostList = new ArrayList<String>(okHostSet);
        // ArrayList<String> allHostList = new ArrayList<String>(allHostSet);
        // JSONObject resultHostObj = new JSONObject();
        // int x = 0;
        // for(String allHost : allHostList){
        //   for(String okHost : okHostList){
        //     if(allHost.equals(okHost)){
        //       resultHostObj.put(allHostList.get(x).trim(), allHostObj.get(allHostList.get(x).trim()));
        //       break;
        //     }else{
        //       resultHostObj.put(allHostList.get(x).trim(), allHostObj.get(allHostList.get(x).trim()));
        //     }
        //   }
        //   x++;
        // }
        // System.out.println("resultHostObj========"+resultHostObj);


        // JSONArray resultsArray = (JSONArray) jsonObj.get("results");
        // JSONArray summary_fieldsArray = new JSONArray();
        // JSONObject summary_fieldsObj = new JSONObject();
        // int i = 0;
        // for(Object tmp : resultsArray){
        //   tmp = resultsArray.get(i);
        //   summary_fieldsObj = (JSONObject) tmp;
        //   summary_fieldsObj = (JSONObject) summary_fieldsObj.get("summary_fields");
        //   summary_fieldsArray.add(summary_fieldsObj);
        //   i++;
        // }
        // JSONObject allHostObj = new JSONObject();
        // i = 0;
        // for(Object tmp : summary_fieldsArray){
        //   tmp = summary_fieldsArray.get(i);
        //   JSONObject host = new JSONObject();
        //   host = (JSONObject) summary_fieldsArray.get(i);
        //   host = (JSONObject) host.get("host");
        //   if(host != null){
        //   allHostObj.put(host.get("name"), host.get("description"));
        //   }
        //   i++;
        // }
        // JSONObject okHostObj = new JSONObject();
        // okHostObj = (JSONObject) resultsArray.get(0);
        // okHostObj = (JSONObject) okHostObj.get("event_data");
        // okHostObj = (JSONObject) okHostObj.get("ok");
        // Set<String> okHostSet = new HashSet<>(okHostObj.keySet());
        // Set<String> allHostSet = new HashSet<>(allHostObj.keySet());
        // ArrayList<String> okHostList = new ArrayList<String>(okHostSet);
        // ArrayList<String> allHostList = new ArrayList<String>(allHostSet);
        // JSONObject resultHostObj = new JSONObject();
        // int x = 0;
        // for(String allHost : allHostList){
        //   for(String okHost : okHostList){
        //     if(allHost.equals(okHost)){
        //       resultHostObj.put(allHostObj.get(allHostList.get(x).trim()), "Y");
        //       break;
        //     }else{
        //       resultHostObj.put(allHostObj.get(allHostList.get(x).trim()), "N");
        //     }
        //   }
        //   x++;
        // }
        // System.out.println("resultHostObj========"+resultHostObj);
//         String objects = response.block();
//         System.out.println("objects======"+objects);
//         JSONParser jsonParser = new JSONParser();
//         JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
//         JSONArray jsonArr = (JSONArray) jsonObj.get("results");
//         JSONArray jsonArr2 = new JSONArray();
//         System.out.println("jssArr====="+(JSONObject) jsonArr.get(0));
//         //System.out.println("jssArr222222====="+(JSONObject) jsonArr.);
//         objects = "";
//         JSONObject jj = new JSONObject();
//         JSONObject jj2 = new JSONObject();
//         JSONObject jj3 = new JSONObject();
//         JSONObject jj4 = new JSONObject();
//         String aaa = "";
//         String b = "";
//         String c = "";
//         for(int i = 0; i < jsonArr.size();i++){
//           //System.out.println(i+"========"+jsonArr.get(i));
//           jj = (JSONObject) jsonArr.get(i);
//           jj = (JSONObject) jj.get("summary_fields");
//           jsonArr2.add(jj);
//           //jj = (JSONObject) jj.get("host");
//           System.out.println(i+"aaaaaaaaaaaaaaaa==="+jj.toJSONString());
//           //jj3.put("name", jj.get("name"));
//           //jj3.put("description", jj.get("description"));
//           //System.out.println(i+"jssArr====="+jj3.toJSONString());
//           aaa += jj.get("name");
//           aaa += jj.get("description");
//           aaa += jj.get("ok");
//           aaa += jj.get("changed");
//           //jj = (JSONObject) jj.get("ok");
//           objects += jj.get("ok");
//           objects += jj.get("dark");
//         }
//           jj = (JSONObject) jsonArr.get(0);
//           jj = (JSONObject) jj.get("event_data");
//           jj2 = (JSONObject) jj.get("processed");
//           Set<String> listA = new HashSet<>(jj2.keySet());
//           jj2 = (JSONObject) jj.get("ok");
//           Set<String> listB = new HashSet<>(jj2.keySet());
//           JSONArray aaaa = new JSONArray();
//         ArrayList<String> listA1 = new ArrayList<String>(listA);
//         ArrayList<String> listB1 = new ArrayList<String>(listB);
//         System.out.println("all"+listA1);
//         System.out.println("success"+listB1);
//         //former_ppm_name 차집합 ppm_name
//         listA1.removeAll(listB1);
//         System.out.println("fail"+listA1);
        
// for(int y = 0; y < jsonArr2.size(); y++){
//   JSONObject jsonObj22 = new JSONObject();
//   jsonObj22 = (JSONObject) jsonArr2.get(y);
//   jsonObj22 = (JSONObject) jsonObj22.get("host");
//   if(jsonObj22 != null){
//   jj3.put(jsonObj22.get("name"), jsonObj22.get("description"));
//   //jj3.put("description"+y, jsonObj22.get("description"));
//   //jj3.put("id"+y, jsonObj22.get("id"));
//   }
//   //jj3.put("name"+y, jsonObj22.get("name"));
//   //jj3.put("description"+y, jsonObj22.get("description"));
// }
// System.out.println("ffffffffffffffff======"+jj3.size());
// Set<String> listC = new HashSet<>(jj3.keySet());
// ArrayList<String> listC1 = new ArrayList<String>(listC);
// System.out.println("size===="+listC1.size());
// for(int x = 0; x < listC1.size(); x++){
//   for(int z = 0; z < listB1.size(); z++){
//     System.out.println(listC1.get(x)+"======="+listB1.get(z));
//     if(listC1.get(x).equals(listB1.get(z))){
//       System.out.println("같음");
//       System.out.println(x+"=========="+z);
//       jj4.put(jj3.get(listC1.get(x).trim()), "Y");
//       break;
//     }else{
//       System.out.println("다름");
//       System.out.println(x+"=========="+z);
//       jj4.put(jj3.get(listC1.get(x).trim()), "N");
//     }
  
//   }
    
// }
// //System.out.println("result=================="+jj3);
// System.out.println("result=================="+jj4);

//         System.out.println("jj========"+listA1);
        // for(Object j:jsonArr){
        //   JSONObject jj = (JSONObject) j;
        //   System.out.println("jjjjjjjjjjjjjjjjjjjjjj========"+jj);
        // }
        //jsonObj = (JSONObject) jsonParser.parse(jsonObj.get("results").toString());
        //System.out.println("jsonObj2222======"+jsonObj.get("event_data"));
        return objects.toString();
      } catch (Exception e) {
        //TODO: handle exception
      }
      return null;
  
    }

    @RequestMapping(value="test2")
    public String addInventory(){

      WebClient wc = WebClient.builder()
      .defaultHeaders(header -> header.setBasicAuth("admin","password"))
      .baseUrl("http://192.168.0.220")
      .build();
      
      try {
        String request = "{\"name\": \"invesume2\",\"description\": \"invesume\",\"source\": \"custom\"}";
        LinkedMultiValueMap map = new LinkedMultiValueMap();
        map.add("data", request);
        Mono<String> response = wc.post()
        .uri(UriBuilder -> UriBuilder
        .path("/api/v2/inventories/").path("{id}/").path("inventory_sources/")
        .build(3))
        .contentType(MediaType.APPLICATION_JSON)
        .body(BodyInserters.fromValue(request))
        //에러 확인
        .exchange().flatMap(clientResponse -> {
          if (clientResponse.statusCode().is5xxServerError()) {
              clientResponse.body((clientHttpResponse, context) -> {
                  return clientHttpResponse.getBody();
              });
              return clientResponse.bodyToMono(String.class);
          }
          else
              return clientResponse.bodyToMono(String.class);
      });
        //.bodyValue(request)
        //.accept(MediaType.APPLICATION_JSON)
        //.retrieve()
        //.bodyToMono(String.class); 

        String objects = response.block();
        return objects.toString();
      } catch (Exception e) {
        //TODO: handle exception
      }
      return null;
  
    }

    @RequestMapping(value="test3")
    public String addHosts(){

      WebClient wc = WebClient.builder()
      .defaultHeaders(header -> header.setBasicAuth("admin","password"))
      .baseUrl("http://192.168.0.220").build();
      
      try {
        String request = "{\"name\": \"192.168.0.225\",\"description\": \"192.168.0.225\",\"inventory\": 13}";
        //"\thosts:\n"+
        //"\t\t192.168.0.225}\"";
        System.out.println("request====="+request);
        Mono<String> response = wc.post().uri(UriBuilder -> UriBuilder
        .path("/api/v2/groups/").path("{id}/").path("hosts/")
        .build(11))
        .contentType(MediaType.APPLICATION_JSON)
        .body(BodyInserters.fromValue(request))
        .exchange().flatMap(clientResponse -> {
          if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
              clientResponse.body((clientHttpResponse, context) -> {
                  return clientHttpResponse.getBody();
              });
              return clientResponse.bodyToMono(String.class);
          }
          else
              return clientResponse.bodyToMono(String.class);
      });
        //.accept(MediaType.APPLICATION_JSON)
        //.retrieve()
        //.bodyToMono(String.class); 

        String objects = response.block();
        return objects.toString();
      } catch (Exception e) {
        //TODO: handle exception
      }
      return null;
  
    }

    @RequestMapping(value="test4")
    public String makePolicy(){

      WebClient wc = WebClient.builder()
      .defaultHeaders(header -> header.setBasicAuth("admin","password"))
      .baseUrl("http://192.168.0.220").build();
      
      try {
          String request = "{\"credential\": 3,\"limit\": \"1\",\"inventory\": 21,\"module_name\": \"shell\",\"module_args\": \"echo '{\\\"PATH\\\":\\\"/timeshift/snapshots\\\",\\\"NAME\\\":\\\"2021-12-10_12-30-01\\\"}' > /etc/hamonize/recovery/2aaaaa.hm\",\"become_enabled\": \"True\",\"verbosity\": 0}";
          System.out.println("request====="+request);
          Mono<String> response = wc.post().uri(UriBuilder -> UriBuilder
          .path("/api/v2/ad_hoc_commands/")
          .build())
          .contentType(MediaType.APPLICATION_JSON)
          .body(BodyInserters.fromValue(request))
          .exchange().flatMap(clientResponse -> {
            if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
                clientResponse.body((clientHttpResponse, context) -> {
                    return clientHttpResponse.getBody();
                });
                return clientResponse.bodyToMono(String.class);
            }
            else
                return clientResponse.bodyToMono(String.class);
        });
          //.accept(MediaType.APPLICATION_JSON)
          //.retrieve()
          //.bodyToMono(String.class); 

  String objects = response.block();
  return objects.toString();
  //JSONParser jsonParser = new JSONParser();
  //JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
      } catch (Exception e) {
        //TODO: handle exception
      }
      return null;
  
    }

    @RequestMapping(value="test5")
    public String deleteorg(){

      WebClient wc = WebClient.builder()
      .defaultHeaders(header -> header.setBasicAuth("admin","password"))
      .baseUrl("http://192.168.0.220").build();
      
      try {
          String request = "{\"name\": 3,\"inventory\": 20}";
          System.out.println("request====="+request);
          Mono<String> response = wc.delete().uri(UriBuilder -> UriBuilder
          .path("/api/v2/groups/").path("{id}/")
          .build(46))
          //.contentType(MediaType.APPLICATION_JSON)
          //.body(BodyInserters.fromValue(request))
          .exchange().flatMap(clientResponse -> {
            if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
                clientResponse.body((clientHttpResponse, context) -> {
                    return clientHttpResponse.getBody();
                });
                return clientResponse.bodyToMono(String.class);
            }
            else
                return clientResponse.bodyToMono(String.class);
        });
          //.accept(MediaType.APPLICATION_JSON)
          //.retrieve()
          //.bodyToMono(String.class); 

  String objects = response.block();
  return objects.toString();
  //JSONParser jsonParser = new JSONParser();
  //JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
      } catch (Exception e) {
        //TODO: handle exception
      }
      return null;
  
    }

  }