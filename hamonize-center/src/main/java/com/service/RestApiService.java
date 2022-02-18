package com.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import com.mapper.IOrgMapper;
import com.mapper.IPcMangrMapper;
import com.model.OrgVo;
import com.model.PcMangrVo;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClient.RequestBodySpec;

import reactor.core.publisher.Mono;

@Service
public class RestApiService {

  @Autowired
  WebClient webClient;

  @Autowired
  IOrgMapper orgMapper;

  @Autowired
  IPcMangrMapper pcMangrMapper;

  public int addRootOrg(OrgVo orgvo) throws ParseException
	{
		String request = "{\"name\": \""+orgvo.getOrg_nm()+"\",\"description\": \""+orgvo.getOrg_nm()+"\",\"organization\": 1}";
        Mono<String> response = webClient.post()
        .uri(UriBuilder -> UriBuilder
        .path("/api/v2/inventories/")
        .build())
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
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
				orgvo.setInventory_id((Long) jsonObj.get("id"));
				request = "{\"name\": \""+orgvo.getSeq()+"\",\"description\": \""+orgvo.getOrg_nm()+"\",\"inventory\": \""+orgvo.getInventory_id()+"\"}";
				response = webClient.post()
        .uri(UriBuilder -> UriBuilder
        .path("/api/v2/groups/")
        .build())
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
			jsonObj = (JSONObject) jsonParser.parse(response.block());
			orgvo.setGroup_id((Long) jsonObj.get("id"));
			int result = orgMapper.addAwxId(orgvo);
			return result;
	}

	public int addDownOrg(OrgVo orgvo) throws ParseException
	{
		String request = "{\"name\": \""+orgvo.getSeq()+"\",\"description\": \""+orgvo.getOrg_nm()+"\",\"inventory\": \""+orgvo.getInventory_id()+"\"}";
        Mono<String> response = webClient.post()
        .uri(UriBuilder -> UriBuilder
        .path("/api/v2/groups/").path("{id}/").path("children/")
        .build(orgvo.getGroup_id()))
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
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
				orgvo.setGroup_id((Long) jsonObj.get("id"));
				int result = orgMapper.addAwxId(orgvo);
				return result;
	}

  public void updateOrg(OrgVo orgvo) throws ParseException
	{
		String request = "{\"name\": \""+orgvo.getSeq()+"\",\"description\": \""+orgvo.getOrg_nm()+"\",\"inventory\": \""+orgvo.getInventory_id()+"\"}";
        Mono<String> response = webClient.patch()
        .uri(UriBuilder -> UriBuilder
        .path("/api/v2/groups/").path("{id}/")
        .build(orgvo.getGroup_id()))
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
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
				//orgvo.setGroup_id((Long) jsonObj.get("id"));
				//int result = orgMapper.addAwxId(orgvo);
				//return result;
	}

  public void deleteOrg(OrgVo orgvo) throws ParseException
	{
		//String request = "{\"name\": \""+orgvo.getSeq()+"\",\"description\": \""+orgvo.getOrg_nm()+"\",\"inventory\": \""+orgvo.getInventory_id()+"\"}";
        Mono<String> response = webClient.delete()
        .uri(UriBuilder -> UriBuilder
        .path("/api/v2/groups/").path("{id}/")
        .build(orgvo.getGroup_id()))
        //.contentType(MediaType.APPLICATION_JSON)
        //.body(BodyInserters.fromValue(request))
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
        //System.out.println("oject==========="+objects.toString());
				//JSONParser jsonParser = new JSONParser();
				//JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
				//orgvo.setGroup_id((Long) jsonObj.get("id"));
				//int result = orgMapper.addAwxId(orgvo);
				//return result;
	}

  public int addHost(PcMangrVo hdVo, OrgVo orgNumChkVo) throws ParseException
  {
    String request = "{\"name\": \""+hdVo.getPc_vpnip()+"\",\"description\": \""+hdVo.getPc_uuid()+"\",\"inventory\": "+orgNumChkVo.getInventory_id()+"}";
    System.out.println("request====="+request);
    Mono<String> response = webClient.post().uri(UriBuilder -> UriBuilder
    .path("/api/v2/groups/").path("{id}/").path("hosts/")
    .build(orgNumChkVo.getGroup_id()))
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
    JSONParser jsonParser = new JSONParser();
    JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
    hdVo.setHost_id((Long) jsonObj.get("id"));
    int result = pcMangrMapper.addHostId(hdVo);
  return result;
}

public JSONObject makePolicy(Map<String, Object> params) throws ParseException
  {
    String request = "{\"credential\": 3,\"limit\": \""+params.get("org_seq")+"\",\"inventory\": "+params.get("inventory_id")
    +",\"module_name\": \"shell\",\"module_args\": \"echo '"+params.get("output")+"' > "+params.get("policyFilePath")+" | touch "+params.get("policyRunFilePath")+"\",\"become_enabled\": \"True\",\"verbosity\": 0,\"forks\": 10}";
    System.out.println("request====="+request);
    Mono<String> response = webClient.post().uri(UriBuilder -> UriBuilder
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
    //System.out.println("objects====="+objects);
    JSONParser jsonParser = new JSONParser();
    JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
    //System.out.println("jsonObj.get======"+jsonObj.get("id").toString());
    
    int result = Integer.parseInt(jsonObj.get("id").toString());
    //JSONObject jsonResultObj = new JSONObject();
    // try {
    //   Thread.sleep(3000);
    // } catch (InterruptedException e) {
    //   // TODO Auto-generated catch block
    //   e.printStackTrace();
    // }
    JSONObject jsonResultObj = checkPolicyJobResult(result);
    System.out.println("jsonResultObj====="+jsonResultObj.get("status"));
  //   Thread subTread2 = new Thread() {
  //     public void run() {
  //       try {
  //         jsonResultObj = checkPolicyJobResult(result);
  //       } catch (ParseException e) {
  //         // TODO Auto-generated catch block
  //         e.printStackTrace();
  //       }
  //     }
  // };
  // try {
  //   subTread2.sleep(3000);
  //   System.out.println("jsonResultObj====="+jsonResultObj.get("status"));
  // } catch (InterruptedException e) {
  //   // TODO Auto-generated catch block
  //   e.printStackTrace();
  // }
  return jsonResultObj;
}

public JSONObject checkPolicyJobResult(int id) throws ParseException{

  Mono<String> response = webClient.get().uri(UriBuilder -> UriBuilder
  .path("/api/v2/ad_hoc_commands/").path("{id}/")
    .build(id))
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

        String objects = response.block();
        System.out.println("objects====="+objects);
        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
        System.out.println("jsonObj===="+jsonObj.toJSONString());
        // JSONArray resultsArray = (JSONArray) jsonObj.get("results");
        // JSONArray summary_fieldsArray = new JSONArray();
        // JSONObject summary_fieldsObj = new JSONObject();
        // JSONObject okHostObj = new JSONObject();
        // int i = 0;
        // for(Object tmp : resultsArray){
        //   tmp = resultsArray.get(i);
        //   summary_fieldsObj = (JSONObject) tmp;
        //   if(i == 0)
        //   {
        //     okHostObj = summary_fieldsObj;
        //   }
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
        return jsonObj;
}
  
}
