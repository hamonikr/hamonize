// package com;

// import com.controller.LoginController;

// import org.junit.Test;
// import org.junit.runner.RunWith;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
// import org.springframework.test.context.junit4.SpringRunner;
// import org.springframework.test.web.servlet.MockMvc;
// import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
// import org.springframework.util.LinkedMultiValueMap;
// import org.springframework.util.MultiValueMap;
// import static org.hamcrest.Matchers.equalTo;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// @RunWith(SpringRunner.class)
// @WebMvcTest(LoginController.class)
// public class LoginControllerTests {

//     @Autowired
//     private MockMvc mockMvc;

//     @Test
//     public void loginTest() throws Exception{
//         MultiValueMap<String, String> info = new LinkedMultiValueMap<>();

//         info.add("user_id", "admin");
//         info.add("pass_wd", "admin");

//         // mockMvc.perform(get("/insession").params(info).andExpect)
//         mockMvc.perform(MockMvcRequestBuilders.post("/login/insession.do").params(info))
//         .andExpect(status().isOk())
//         .andExpect(content().string(equalTo("1")));

//     }
           
// }
