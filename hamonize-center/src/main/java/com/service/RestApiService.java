package com.service;

import java.util.Map;

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

  public int addHost(PcMangrVo hdVo, OrgVo orgVo) throws ParseException
  {
    String request = "{\"name\": \""+hdVo.getPc_vpnip()+"\",\"description\": \""+hdVo.getPc_uuid()+"\",\"inventory\": "+orgVo.getInventory_id()+"}";
    System.out.println("request====="+request);
    Mono<String> response = webClient.post().uri(UriBuilder -> UriBuilder
    .path("/api/v2/groups/").path("{id}/").path("hosts/")
    .build(orgVo.getGroup_id()))
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

public void updateHost(PcMangrVo hdVo, OrgVo orgVo) throws ParseException
  {
    String request = "{\"name\": \""+hdVo.getPc_vpnip()+"\",\"description\": \""+hdVo.getPc_uuid()+"\",\"inventory\": "+orgVo.getInventory_id()+"}";
    System.out.println("request====="+request);
    Mono<String> response = webClient.patch().uri(UriBuilder -> UriBuilder
    .path("/api/v2/hosts/").path("{id}/")
    .build(hdVo.getHost_id()))
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
    //JSONParser jsonParser = new JSONParser();
    //JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
  //return result;
}

public JSONObject makePolicyToGroup(Map<String, Object> params) throws ParseException
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
    
    Integer result = Integer.parseInt(jsonObj.get("id").toString());
    JSONObject jsonResultObj = new JSONObject();
    if(result != null){
      jsonResultObj = checkPolicyJobResult(result);
    }
  return jsonResultObj;
}

public JSONObject makePolicyToSingle(Map<String, Object> params) throws ParseException
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
    
    Integer result = Integer.parseInt(jsonObj.get("id").toString());
    JSONObject jsonResultObj = new JSONObject();
    if(result != null){
      jsonResultObj = checkPolicyJobResult(result);
    }
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
        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
        return jsonObj;
}

public JSONArray addAnsibleJobEvent(int id) throws ParseException{

  Mono<String> response = webClient.get().uri(UriBuilder -> UriBuilder
  .path("/api/v2/ad_hoc_commands/").path("{id}/").path("events/")
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
        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
        System.out.println("jsonObj============"+jsonObj);
        JSONArray resultsArray = (JSONArray) jsonObj.get("results");
        JSONArray makeResultArray = new JSONArray();
        int index = 0;
        for(Object tmp : resultsArray){
          JSONObject summary_fieldsObj = new JSONObject();
          summary_fieldsObj = (JSONObject) tmp;
          summary_fieldsObj = (JSONObject) summary_fieldsObj.get("summary_fields");
          if(!summary_fieldsObj.isEmpty())
          {
            JSONObject makeResultObj = (JSONObject) tmp;
            System.out.println(index+"=======makeResultObj=============="+makeResultObj);
            makeResultArray.add(makeResultObj);
          }
          
            index++;
        }
        JSONArray finalResultArray = new JSONArray();
        System.out.println("makeResultArray========"+makeResultArray.size());
        System.out.println("makeResultArray========"+makeResultArray.toJSONString());
        JSONObject processed = new JSONObject();
          processed = (JSONObject) resultsArray.get(0);
          processed = (JSONObject) processed.get("event_data");
          processed = (JSONObject) processed.get("processed");
          finalResultArray.add(processed);
        for(Object tmp : makeResultArray){
          JSONObject finalResult = new JSONObject();
          finalResult = (JSONObject) tmp;
          System.out.println("finalResult-============="+finalResult);
          String stdout = finalResult.get("stdout").toString();
          System.out.println("stdout============="+stdout);
          if(!stdout.isEmpty())
          {
            finalResultArray.add(finalResult);
          }
        }
        System.out.println("finalResultArray=========="+finalResultArray.size());
        System.out.println("finalResultArray=========="+finalResultArray.toJSONString());
        return finalResultArray;
}
  
}
