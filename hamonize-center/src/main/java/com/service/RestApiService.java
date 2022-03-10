package com.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.mapper.IOrgMapper;
import com.mapper.IPcMangrMapper;
import com.mapper.IPolicyCommonMapper;
import com.model.OrgVo;
import com.model.PcMangrVo;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import reactor.core.publisher.Mono;

@Service
public class RestApiService {

  @Autowired
  WebClient webClient;

  @Autowired
  IOrgMapper orgMapper;

  @Autowired
  IPcMangrMapper pcMangrMapper;

  @Autowired
  IPolicyCommonMapper policyCommonMapper;

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
      //   .exchange().flatMap(clientResponse -> {
      //     if (clientResponse.statusCode().is5xxServerError()) {
      //         clientResponse.body((clientHttpResponse, context) -> {
      //             return clientHttpResponse.getBody();
      //         });
      //         return clientResponse.bodyToMono(String.class);
      //     }
      //     else
      //         return clientResponse.bodyToMono(String.class);
      // });
        .accept(MediaType.APPLICATION_JSON)
        .retrieve()
        .bodyToMono(String.class);

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
        .accept(MediaType.APPLICATION_JSON)
        .retrieve()
        .bodyToMono(String.class);
        //에러 확인
      //   .exchange().flatMap(clientResponse -> {
      //     if (clientResponse.statusCode().is5xxServerError()) {
      //         clientResponse.body((clientHttpResponse, context) -> {
      //             return clientHttpResponse.getBody();
      //         });
      //         return clientResponse.bodyToMono(String.class);
      //     }
      //     else
      //         return clientResponse.bodyToMono(String.class);
      // });
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
      //   .exchange().flatMap(clientResponse -> {
      //     if (clientResponse.statusCode().is5xxServerError()) {
      //         clientResponse.body((clientHttpResponse, context) -> {
      //             return clientHttpResponse.getBody();
      //         });
      //         return clientResponse.bodyToMono(String.class);
      //     }
      //     else
      //         return clientResponse.bodyToMono(String.class);
      // });
        .accept(MediaType.APPLICATION_JSON)
        .retrieve()
        .bodyToMono(String.class); 

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
      //   .exchange().flatMap(clientResponse -> {
      //     if (clientResponse.statusCode().is5xxServerError()) {
      //         clientResponse.body((clientHttpResponse, context) -> {
      //             return clientHttpResponse.getBody();
      //         });
      //         return clientResponse.bodyToMono(String.class);
      //     }
      //     else
      //         return clientResponse.bodyToMono(String.class);
      // });
        .accept(MediaType.APPLICATION_JSON)
        .retrieve()
        .bodyToMono(String.class); 

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
      //   .exchange().flatMap(clientResponse -> {
      //     if (clientResponse.statusCode().is5xxServerError()) {
      //         clientResponse.body((clientHttpResponse, context) -> {
      //             return clientHttpResponse.getBody();
      //         });
      //         return clientResponse.bodyToMono(String.class);
      //     }
      //     else
      //         return clientResponse.bodyToMono(String.class);
      // });
        .accept(MediaType.APPLICATION_JSON)
        .retrieve()
        .bodyToMono(String.class); 

        String objects = response.block();
        //System.out.println("oject==========="+objects.toString());
				//JSONParser jsonParser = new JSONParser();
				//JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
				//orgvo.setGroup_id((Long) jsonObj.get("id"));
				//int result = orgMapper.addAwxId(orgvo);
				//return result;
	}

  public int addHost(PcMangrVo hdVo, OrgVo orgVo) throws ParseException
  {
    String request = "{\"name\": \""+hdVo.getPc_vpnip()+"\",\"description\": \""+hdVo.getPc_uuid()+"\",\"inventory\": "+orgVo.getInventory_id()+"}";
    System.out.println("request====="+request);
    Mono<String> response = webClient.post().uri(UriBuilder -> UriBuilder
    .path("/api/v2/groups/").path("{id}/").path("hosts/")
    .build(orgVo.getGroup_id()))
    .contentType(MediaType.APPLICATION_JSON)
    .body(BodyInserters.fromValue(request))
  //   .exchange().flatMap(clientResponse -> {
  //     if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
  //         clientResponse.body((clientHttpResponse, context) -> {
  //             return clientHttpResponse.getBody();
  //         });
  //         return clientResponse.bodyToMono(String.class);
  //     }
  //     else
  //         return clientResponse.bodyToMono(String.class);
  // });
    .accept(MediaType.APPLICATION_JSON)
    .retrieve()
    .bodyToMono(String.class); 

    String objects = response.block();
    JSONParser jsonParser = new JSONParser();
    JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
    hdVo.setHost_id((Long) jsonObj.get("id"));
    int result = pcMangrMapper.addHostId(hdVo);
  return result;
}

public void updateHost(PcMangrVo hdVo, OrgVo orgVo) throws ParseException
  {
    String request = "{\"name\": \""+hdVo.getPc_vpnip()+"\",\"description\": \""+hdVo.getPc_uuid()+"\",\"inventory\": "+orgVo.getInventory_id()+"}";
    System.out.println("request====="+request);
    Mono<String> response = webClient.patch().uri(UriBuilder -> UriBuilder
    .path("/api/v2/hosts/").path("{id}/")
    .build(hdVo.getHost_id()))
    .contentType(MediaType.APPLICATION_JSON)
    .body(BodyInserters.fromValue(request))
  //   .exchange().flatMap(clientResponse -> {
  //     if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
  //         clientResponse.body((clientHttpResponse, context) -> {
  //             return clientHttpResponse.getBody();
  //         });
  //         return clientResponse.bodyToMono(String.class);
  //     }
  //     else
  //         return clientResponse.bodyToMono(String.class);
  // });
    .accept(MediaType.APPLICATION_JSON)
    .retrieve()
    .bodyToMono(String.class); 

    String objects = response.block();
    JSONParser jsonParser = new JSONParser();
    JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
  //return result;
}

public void deleteHost(PcMangrVo hdVo) throws ParseException
  {
    //String request = "{\"name\": \""+hdVo.getPc_vpnip()+"\",\"description\": \""+hdVo.getPc_uuid()+"\",\"inventory\": "+orgNumChkVo.getInventory_id()+"}";
    //System.out.println("request====="+request);
    Mono<String> response = webClient.delete().uri(UriBuilder -> UriBuilder
    .path("/api/v2/hosts/").path("{id}/")
    .build(hdVo.getHost_id()))
    //.contentType(MediaType.APPLICATION_JSON)
    //.body(BodyInserters.fromValue(request))
  //   .exchange().flatMap(clientResponse -> {
  //     if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
  //         clientResponse.body((clientHttpResponse, context) -> {
  //             return clientHttpResponse.getBody();
  //         });
  //         return clientResponse.bodyToMono(String.class);
  //     }
  //     else
  //         return clientResponse.bodyToMono(String.class);
  // });
    .accept(MediaType.APPLICATION_JSON)
    .retrieve()
    .bodyToMono(String.class); 

    String objects = response.block();
    //JSONParser jsonParser = new JSONParser();
    //JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
  //return result;
}

public JSONObject makePolicyToGroup(Map<String, Object> params) throws ParseException, InterruptedException
  {
    String request = "{\"credential\": 3,\"limit\": \""+params.get("org_seq")+"\",\"inventory\": "+params.get("inventory_id")
    +",\"module_name\": \"shell\",\"module_args\": \"echo '"+params.get("output")+"' > "+params.get("policyFilePath")+" | touch "+params.get("policyRunFilePath")+"\",\"become_enabled\": \"True\",\"verbosity\": 0,\"forks\": 10}";
    System.out.println("request====="+request);
    Mono<String> response = webClient.post().uri(UriBuilder -> UriBuilder
    .path("/api/v2/ad_hoc_commands/")
    .build())
    .contentType(MediaType.APPLICATION_JSON)
    .body(BodyInserters.fromValue(request))
  //   .exchange().flatMap(clientResponse -> {
  //     if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
  //         clientResponse.body((clientHttpResponse, context) -> {
  //             return clientHttpResponse.getBody();
  //         });
  //         return clientResponse.bodyToMono(String.class);
  //     }
  //     else
  //         return clientResponse.bodyToMono(String.class);
  // });
    .accept(MediaType.APPLICATION_JSON)
    .retrieve()
    .bodyToMono(String.class); 

    String objects = response.block();
    JSONParser jsonParser = new JSONParser();
    JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
    //System.out.println("jsonObj.get======"+jsonObj.get("id").toString());
    
    Integer result = Integer.parseInt(jsonObj.get("id").toString());
    params.put("job_id",result);
    params.put("object",objects);
    params.put("id",result);
    policyCommonMapper.addAnsibleJobEventByGroup(params);
    JSONObject jsonResultObj = new JSONObject();
    if(result != null){
      jsonResultObj = checkAndAddPolicyJobResult(params);
    }
  return jsonResultObj;
}

public JSONObject makePolicyToSingle(Map<String, Object> params) throws ParseException, InterruptedException
  {
    //String output = params.get("module_args").toString();
    //output = output.replaceAll("\"", "\\\\\\\"");
    String request = "{\"credential\": 3,\"module_name\": \"shell\",\"module_args\": \"echo '"+params.get("output")+"' > "+params.get("policyFilePath")+" | touch "+params.get("policyRunFilePath")+"\",\"become_enabled\": \"True\",\"verbosity\": 0}";
    System.out.println("request====="+request);
    Mono<String> response = webClient.post().uri(UriBuilder -> UriBuilder
    .path("/api/v2/hosts/").path("{id}/").path("ad_hoc_commands/")
    .build(params.get("host_id")))
    .contentType(MediaType.APPLICATION_JSON)
    .body(BodyInserters.fromValue(request))
  //   .exchange().flatMap(clientResponse -> {
  //     if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
  //         clientResponse.body((clientHttpResponse, context) -> {
  //             return clientHttpResponse.getBody();
  //         });
  //         return clientResponse.bodyToMono(String.class);
  //     }
  //     else
  //         return clientResponse.bodyToMono(String.class);
  // });
    .accept(MediaType.APPLICATION_JSON)
    .retrieve()
    .bodyToMono(String.class); 

    String objects = response.block();
    JSONParser jsonParser = new JSONParser();
    JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
    params.put("job_id",jsonObj.get("id").toString());
    Integer result = Integer.parseInt(jsonObj.get("id").toString());
    JSONObject jsonResultObj = new JSONObject();
    if(result != null){
      jsonResultObj = checkPolicyJobResult(params);
    }
  return jsonResultObj;
}

public JSONObject makeCommandToSingle(Map<String, Object> params) throws ParseException, InterruptedException
  {
    //String output = params.get("module_args").toString();
    //output = output.replaceAll("\"", "\\\\\\\"");
    String request = "{\"credential\": 3,\"module_name\": \"shell\",\"module_args\": \""+params.get("input")+"\",\"become_enabled\": \"True\",\"verbosity\": 0}";
    System.out.println("request====="+request);
    Mono<String> response = webClient.post().uri(UriBuilder -> UriBuilder
    .path("/api/v2/hosts/").path("{id}/").path("ad_hoc_commands/")
    .build(params.get("host_id")))
    .contentType(MediaType.APPLICATION_JSON)
    .body(BodyInserters.fromValue(request))
    // .exchangeToMono(clientResponse -> {
    //   if(clientResponse.statusCode().equals(HttpStatus.OK)){
    //     return clientResponse.bodyToMono(String.class);
    //   }else if(clientResponse.statusCode().is4xxClientError()){
    //     clientResponse.body((clientHttpResponse, context) -> {
    //       return clientHttpResponse.getBody();
    //   });
    //   }else{
    //     return clientResponse.createException().flatMap(Mono::error);
    //   }
    //   return null;
    // });
    .accept(MediaType.APPLICATION_JSON)
    .retrieve()
    .bodyToMono(String.class); 

    String objects = response.block();
    System.out.println("objects===="+objects.toString());
    JSONParser jsonParser = new JSONParser();
    JSONObject jsonObj = (JSONObject) jsonParser.parse(objects.toString());
    System.out.println("jsonObj===="+jsonObj);
    params.put("job_id",jsonObj.get("id").toString() );
    Integer result = Integer.parseInt(jsonObj.get("id").toString());
    JSONObject jsonResultObj = new JSONObject();
    if(result != null){
      jsonResultObj = checkPolicyJobResult(params);
    }
  return jsonResultObj;
}

public JSONObject checkPolicyJobResult(Map<String, Object> params) throws ParseException{

  Mono<String> response = webClient.get().uri(UriBuilder -> UriBuilder
  .path("/api/v2/ad_hoc_commands/").path("{id}/")
  .build(params.get("job_id")))
  //   .exchange().flatMap(clientResponse -> {
  //     if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
  //         clientResponse.body((clientHttpResponse, context) -> {
  //             return clientHttpResponse.getBody();
  //         });
  //         return clientResponse.bodyToMono(String.class);
  //     }
  //     else
  //         return clientResponse.bodyToMono(String.class);
  // });
  .accept(MediaType.APPLICATION_JSON)
  .retrieve()
  .bodyToMono(String.class); 
    String objects = response.block();
    JSONParser jsonParser = new JSONParser();
    JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
    return jsonObj;
}

public JSONObject checkAndAddPolicyJobResult(Map<String, Object> params) throws ParseException, InterruptedException{

  Mono<String> response = webClient.get().uri(UriBuilder -> UriBuilder
  .path("/api/v2/ad_hoc_commands/").path("{id}/")
  .build(params.get("job_id")))
  //   .exchange().flatMap(clientResponse -> {
  //     if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
  //         clientResponse.body((clientHttpResponse, context) -> {
  //             return clientHttpResponse.getBody();
  //         });
  //         return clientResponse.bodyToMono(String.class);
  //     }
  //     else
  //         return clientResponse.bodyToMono(String.class);
  // });
  .accept(MediaType.APPLICATION_JSON)
  .retrieve()
  .bodyToMono(String.class); 
    System.out.println("params=============="+params);
    String objects = response.block();
    JSONParser jsonParser = new JSONParser();
    JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
    System.out.println("aaaaaaaaaaa==="+jsonObj.get("status").toString());
    int i = 0;
    String status = jsonObj.get("status").toString();
    //ThreadService th = new ThreadService(params.get("id"),status);
      // Thread tt = new Thread(th);
    if(status.equals("running") || status.equals("waiting") || status.equals("pending")){
      //tt.start();
      //checkPolicyJobResult(id);
      Thread t1 = new Thread(new Runnable() {
        @Override
        public void run() {
            // code goes here.
            try {
              Thread.sleep(2000);
              JSONObject jsonObj = checkAndAddPolicyJobResult(params);
            } catch (ParseException e) {
              // TODO Auto-generated catch block
              e.printStackTrace();
            } catch (InterruptedException e) {
              // TODO Auto-generated catch block
              e.printStackTrace();
            }
        }
    });
    t1.start();
    }else{
      System.out.println("end!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      //addAnsibleJobEventByHosts(Integer.parseInt(jsonObj.get("id").toString()));
      addAnsibleJobEventByHosts(params,0);
    }
    return jsonObj;
}

public JSONObject addAnsibleJobEventByHosts(Map<String, Object> params,int count) throws ParseException, InterruptedException{

  Mono<String> response = webClient.get().uri(UriBuilder -> UriBuilder
  .path("/api/v2/ad_hoc_commands/").path("{id}/").path("events/")
  .build(params.get("job_id")))
  //   .exchange().flatMap(clientResponse -> {
  //     if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
  //         clientResponse.body((clientHttpResponse, context) -> {
  //             return clientHttpResponse.getBody();
  //         });
  //         return clientResponse.bodyToMono(String.class);
  //     }
  //     else
  //         return clientResponse.bodyToMono(String.class);
  // });
  .accept(MediaType.APPLICATION_JSON)
  .retrieve()
  .bodyToMono(String.class); 

        String objects = response.block();
        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
        JSONArray resultsArray = (JSONArray) jsonObj.get("results");
        JSONArray makeResultArray = new JSONArray();
        System.out.println("resultsArray========="+resultsArray);
        int index = 0;
        for(Object tmp : resultsArray){
          JSONObject summary_fieldsObj = new JSONObject();
          summary_fieldsObj = (JSONObject) tmp;
          System.out.println("summary_fieldsObj1111111======"+summary_fieldsObj);
          summary_fieldsObj = (JSONObject) summary_fieldsObj.get("summary_fields");
          System.out.println("summary_fieldsObj2222222======"+summary_fieldsObj);
          if(!summary_fieldsObj.isEmpty())
          {
            JSONObject makeResultObj = (JSONObject) tmp;
            System.out.println("makeResultObj======"+makeResultObj);
            makeResultArray.add(makeResultObj);
          }
          
            index++;
        }
        JSONArray finalResultArray = new JSONArray();
        for(Object tmp : makeResultArray){
          JSONObject finalResult = new JSONObject();
          finalResult = (JSONObject) tmp;
          System.out.println("finalResult====="+finalResult);
          String stdout = finalResult.get("stdout").toString();
          System.out.println("stdout====="+stdout);
          if(!stdout.isEmpty())
          {
            finalResultArray.add(finalResult);
          }
        }
        JSONObject finalResult = new JSONObject();
        finalResult.put("finalResult", finalResultArray);
        
        JSONObject data = new JSONObject();
      JSONArray dataArr = new JSONArray();
      List<Map<String,Object>> resultSet = new ArrayList<Map<String,Object>>();
      Map<String, Object> resultMap;
      data = finalResult;
      dataArr = (JSONArray) data.get("finalResult");
      System.out.println("dataArr.size()============"+dataArr.size());
      for (int i = 0; i < dataArr.size(); i++) {
          resultMap = new HashMap<String, Object>();
          String json = dataArr.get(i).toString();
          JSONParser jsonParser2 = new JSONParser();
          JSONObject jsonObj2 = (JSONObject) jsonParser2.parse(json);
          resultMap.put("result", json);
          resultMap.put("status", jsonObj2.get("changed"));
          resultMap.put("job_id",params.get("job_id"));
          resultSet.add(resultMap);
      }
      params.put("data", resultSet);
      System.out.println("params1111111111111111111=============="+params);
      int pcCount = policyCommonMapper.getPcCountByOrgSeq(params);
      System.out.println("pcCount===="+pcCount);
      // int result = policyCommonMapper.checkCountAnsibleJobId(params);
      //String[] before_url = request.getHeader("referer").split("/");
		  //params.put("before_url", before_url[before_url.length -1]);
      
      if(dataArr.size() < pcCount){
        count++;
        System.out.println("result======="+count);
        if(count > 5){
          return finalResult;
        }
        Thread.sleep(1000);
        addAnsibleJobEventByHosts(params,count);
      }else{
        int result = 0;
        result = policyCommonMapper.addAnsibleJobEventByHosts(params);
      }
      // int result = policyCommonMapper.checkCountAnsibleJobId(params);
      // System.out.println("result===="+result);
			// if(dataArr.size() > result)
			// {
			// 	if(result > 0)
			// 	{
			// 		policyCommonMapper.deleteAnsibleJobEvent(params);
			// 	}
			// 	result = policyCommonMapper.addAnsibleJobEventByHosts(params);
			// }
        return finalResult;
}

public JSONObject addAnsibleJobEventByHost(Map<String, Object> params,int count) throws ParseException, InterruptedException{

  Mono<String> response = webClient.get().uri(UriBuilder -> UriBuilder
  .path("/api/v2/ad_hoc_commands/").path("{id}/").path("events/")
  .build(params.get("job_id")))
  .accept(MediaType.APPLICATION_JSON)
  .retrieve()
  .bodyToMono(String.class); 

        String objects = response.block();
        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
        JSONArray resultsArray = (JSONArray) jsonObj.get("results");
        JSONArray makeResultArray = new JSONArray();
        System.out.println("resultsArray========="+resultsArray);
        int index = 0;
        for(Object tmp : resultsArray){
          JSONObject summary_fieldsObj = new JSONObject();
          summary_fieldsObj = (JSONObject) tmp;
          System.out.println("summary_fieldsObj1111111======"+summary_fieldsObj);
          summary_fieldsObj = (JSONObject) summary_fieldsObj.get("summary_fields");
          System.out.println("summary_fieldsObj2222222======"+summary_fieldsObj);
          if(!summary_fieldsObj.isEmpty())
          {
            JSONObject makeResultObj = (JSONObject) tmp;
            System.out.println("makeResultObj======"+makeResultObj);
            makeResultArray.add(makeResultObj);
          }
          
            index++;
        }
        JSONArray finalResultArray = new JSONArray();
        for(Object tmp : makeResultArray){
          JSONObject finalResult = new JSONObject();
          finalResult = (JSONObject) tmp;
          System.out.println("finalResult====="+finalResult);
          String stdout = finalResult.get("stdout").toString();
          System.out.println("stdout====="+stdout);
          if(!stdout.isEmpty())
          {
            finalResultArray.add(finalResult);
          }
        }
        JSONObject finalResult = new JSONObject();
        finalResult.put("finalResult", finalResultArray);
        
        JSONObject data = new JSONObject();
      JSONArray dataArr = new JSONArray();
      List<Map<String,Object>> resultSet = new ArrayList<Map<String,Object>>();
      Map<String, Object> resultMap;
      data = finalResult;
      dataArr = (JSONArray) data.get("finalResult");
      System.out.println("dataArr.size()============"+dataArr.size());
      for (int i = 0; i < dataArr.size(); i++) {
          resultMap = new HashMap<String, Object>();
          String json = dataArr.get(i).toString();
          JSONParser jsonParser2 = new JSONParser();
          JSONObject jsonObj2 = (JSONObject) jsonParser2.parse(json);
          resultMap.put("result", json);
          resultMap.put("status", jsonObj2.get("changed"));
          resultMap.put("job_id",params.get("job_id"));
          resultSet.add(resultMap);
      }
      params.put("data", resultSet);
      System.out.println("params1111111111111111111=============="+params);
      int pcCount = policyCommonMapper.getPcCountByOrgSeq(params);
      System.out.println("pcCount===="+pcCount);
      // int result = policyCommonMapper.checkCountAnsibleJobId(params);
      //String[] before_url = request.getHeader("referer").split("/");
		  //params.put("before_url", before_url[before_url.length -1]);
      
      if(dataArr.size() < 1){
        count++;
        System.out.println("result======="+count);
        if(count > 5){
          return finalResult;
        }
        Thread.sleep(1000);
        addAnsibleJobEventByHost(params,count);
      }else{
        int result = 0;
        result = policyCommonMapper.addAnsibleJobEventByHost(params);
      }
      // int result = policyCommonMapper.checkCountAnsibleJobId(params);
      // System.out.println("result===="+result);
			// if(dataArr.size() > result)
			// {
			// 	if(result > 0)
			// 	{
			// 		policyCommonMapper.deleteAnsibleJobEvent(params);
			// 	}
			// 	result = policyCommonMapper.addAnsibleJobEventByHosts(params);
			// }
        return finalResult;
}

public JSONArray addAnsibleJobRelaunchEventByHost(int id) throws ParseException{

  Mono<String> response = webClient.get().uri(UriBuilder -> UriBuilder
  .path("/api/v2/ad_hoc_commands/").path("{id}/").path("events/")
  .build(id))
  //   .exchange().flatMap(clientResponse -> {
  //     if (clientResponse.statusCode().is5xxServerError() || clientResponse.statusCode().isError() || clientResponse.statusCode().is4xxClientError()) {
  //         clientResponse.body((clientHttpResponse, context) -> {
  //             return clientHttpResponse.getBody();
  //         });
  //         return clientResponse.bodyToMono(String.class);
  //     }
  //     else
  //         return clientResponse.bodyToMono(String.class);
  // });
  .accept(MediaType.APPLICATION_JSON)
  .retrieve()
  .bodyToMono(String.class); 

        String objects = response.block();
        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
        JSONArray resultsArray = (JSONArray) jsonObj.get("results");
        JSONArray makeResultArray = new JSONArray();
        System.out.println("resultsArray=========="+resultsArray);
        int index = 0;
        for(Object tmp : resultsArray){
          JSONObject summary_fieldsObj = new JSONObject();
          summary_fieldsObj = (JSONObject) tmp;
          summary_fieldsObj = (JSONObject) summary_fieldsObj.get("summary_fields");
          if(!summary_fieldsObj.isEmpty())
          {
            JSONObject makeResultObj = (JSONObject) tmp;
            makeResultArray.add(makeResultObj);
          }
          
            index++;
        }
        JSONArray finalResultArray = new JSONArray();
        // JSONObject processed = new JSONObject();
        //   processed = (JSONObject) resultsArray.get(0);
        //   processed = (JSONObject) processed.get("event_data");
        //   processed = (JSONObject) processed.get("processed");
        //   finalResultArray.add(processed);
        for(Object tmp : makeResultArray){
          JSONObject finalResult = new JSONObject();
          finalResult = (JSONObject) tmp;
          String stdout = finalResult.get("stdout").toString();
          if(!stdout.isEmpty())
          {
            finalResultArray.add(finalResult);
          }
        }
        return finalResultArray;
}
  
}
