package com.util;

import org.apache.http.entity.ContentType;
import org.json.simple.JSONArray;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.util.LinkedMultiValueMap;

@RestController
@RequestMapping(value="test")
public class Test {

    public static void main(String agrs[]){

      WebClient wc = WebClient.builder().baseUrl("http://192.168.0.212").build();

      try {
        //ResponseEntity<JSONArray> response = wc.get().uri(uri -> uri.pathSegment("/api/v2/inventories/","{id}")
        ResponseEntity<JSONArray> response = wc.get().uri("/api/v2/inventories/{id}",1)
        .accept(MediaType.APPLICATION_JSON)
        .retrieve()
        .toEntity(JSONArray.class).block();
        System.out.println("response====="+response);
      } catch (Exception e) {
        //TODO: handle exception
      }
    }

    @RequestMapping(value="test1")
    public String getInventoryList(){

      WebClient wc = WebClient.builder()
      .defaultHeaders(header -> header.setBasicAuth("admin","password"))
      .baseUrl("http://192.168.0.212").build();
      
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

    @RequestMapping(value="test2")
    public String addInventory(){

      WebClient wc = WebClient.builder()
      .defaultHeaders(header -> header.setBasicAuth("admin","password"))
      .baseUrl("http://192.168.0.212")
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
      .baseUrl("http://192.168.0.212").build();
      
      try {
        String request = "{\"name\": \"invesume\",\"description\": \"invesume hostlist\",\"variables\": \"{'hosts': ['192.168.0.225'], 'vars': {'ansible_user': 'hamonikr','ansible_pass': '0745'}}\"}";
        //"\thosts:\n"+
        //"\t\t192.168.0.225}\"";
        System.out.println("request====="+request);
        Mono<String> response = wc.post().uri(UriBuilder -> UriBuilder
        .path("/api/v2/inventories/").path("{id}").path("/hosts/")
        .build(3))
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
  }
