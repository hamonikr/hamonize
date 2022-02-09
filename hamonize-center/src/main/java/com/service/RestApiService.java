package com.service;

import com.mapper.IOrgMapper;
import com.mapper.IPcMangrMapper;
import com.model.OrgVo;
import com.model.PcMangrVo;

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
				request = "{\"name\": \""+orgvo.getOrg_nm()+"\",\"description\": \""+orgvo.getOrg_nm()+"\",\"inventory\": \""+orgvo.getInventory_id()+"\"}";
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
		String request = "{\"name\": \""+orgvo.getOrg_nm()+"\",\"description\": \""+orgvo.getOrg_nm()+"\",\"inventory\": \""+orgvo.getInventory_id()+"\"}";
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

  public int addHost(PcMangrVo hdVo, OrgVo orgNumChkVo) throws ParseException
  {
    String request = "{\"name\": \""+hdVo.getPc_vpnip()+"\",\"description\": \""+hdVo.getPc_vpnip()+"\",\"inventory\": "+orgNumChkVo.getInventory_id()+"}";
    //"\thosts:\n"+
    //"\t\t192.168.0.225}\"";
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
  
}
