package com.util;

import org.json.simple.JSONArray;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
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
        ResponseEntity<JSONArray> response = wc.get().uri(uri -> uri.path("/api/v2/inventories/")
        .queryParam("username", "admin")
        .queryParam("password", "password")
        .build())
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
        .path("/api/v2/inventories/")
        //.queryParam("--user", "admin:password")
        //.queryParam("password", "password")
        .build())
        .accept(MediaType.APPLICATION_JSON)
        .retrieve()
        .bodyToMono(String.class);
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
      .baseUrl("http://192.168.0.212").build();
      
      try {
        String request = "{\"name\":\"invesume\",\"organization\":\"1\",\"description\":\"invesume hostlist\"}";
        LinkedMultiValueMap map = new LinkedMultiValueMap();
        map.add("request", request);
        Mono<String> response = wc.post().uri(UriBuilder -> UriBuilder
        .path("/api/v2/inventories/")
        // .queryParam("name", "invesume")
        // .queryParam("organization", "1")
        // .queryParam("description", "invesumehost")
        .build())
        .body(map)
        .accept(MediaType.APPLICATION_JSON)
        .retrieve()
        .bodyToMono(String.class); 

        String objects = response.block();
        return objects.toString();
      } catch (Exception e) {
        //TODO: handle exception
      }
      return null;
  
    }
  }
