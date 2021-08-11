# Contributing to Hamonize
환영합니다!

먼저 시간내서 프로젝트에 참여해 주셔서 감사합니다.

이 문서는 프로젝트 참여 방법에 대한 가이드 라인 입니다.

언제든지 저희에게 여러분의 아이디어를 PR요청으로 문서변경을 제안해주세요.

## **소스코드 저장소**

하모나이즈 저장소 : 
https://github.com/hamonikr/hamonize

하모니카 프로젝트 깃헙 : https://github.com/hamonikr/

## **개선 제안**
Hamonize 프로젝트에 제안하려는 경우 최대한 상세하게 이슈에 등록해 주세요.

이슈를 작성하기전에 이미 요청이 있는지 이슈 목록을 확인해주세요.

## **버그 보고**
버그 발견시 이슈에 BUG 라벨로 정보를 제공해 주세요.

최대한 상세하게 작성해 주시고 스크린샷을 첨부해주시면 더 좋습니다.

## **참여 가능 목록**

**1.hamonize-center**
* 개발
  * 모든 기능

* 기획 / 퍼블리싱    
  * UI/UX 구성
  * 페이지 작업
  * 기타

* 문서
   * README,CONTRIBUTING 등 문서 작업
   * 기타

**2.hamonize-admin**

* 개발
   * 모든 기능

* 기획 / 퍼블리싱    
  * UI/UX 구성
  * 페이지 작업
  * 기타

* 문서
   * README,CONTRIBUTING 등 문서 작업
   * 기타

**3.hamonize-agent**

* 개발
   * 모든 기능

* 문서
   * README,CONTRIBUTING 등 문서 작업
   * 기타

* Code Style
   * Hamonize-Agent는 NodeJS + Shell Script 사용
    - Linux Coding Style은 해당 링크를 참조하시기 바랍니다.  [ https://www.kernel.org/doc/html/latest/process/coding-style.html]
    - Node.Js 는 Prettier Module를 사용
    - 사용밥업 :  
      - 1. npm i -D prettier or npm i --save-dev Prettier
      - 2. prettier --write "**/*.js"
      - 3. Package.json 추가 
      ```
      {
          ...
          "scripts": {
              "prettier": "prettier --write '**/*.{ts,js,css,html}'"
          }
          ...
      }
      ```
      - 4. npm run prettier

***참여부분을 저희에게 알려주세요. 더욱 자세하게 설명드립니다.**

[이슈](https://github.com/hamonikr/hamonize/issues) 또는 [Slack채널](hamonikr.slack.com)을 이용해 주세요.

#hamonize 방 : 누구나 참여할 수 있는 커뮤니티 채널
</br></br>

## 컨트리뷰션 가이드라인

**1. Fork**

* Upstream Repository를 자신의 GitHub 계정으로 [Fork](https://help.github.com/en/github/getting-started-with-github/fork-a-repo) 합니다.

**2. Clone**

* Fork한 Repository를 자신의 Local working directory로 Clone 합니다.
```text
$ mkdir -p $working_dir
$ cd $working_dir
$ git clone https://github.com/hamonikr/hamonize.git
```

**3. Create a branch**

* 개발용 [branch](https://git-scm.com/book/ko/v2/Git-%EB%B8%8C%EB%9E%9C%EC%B9%98-%EB%B8%8C%EB%9E%9C%EC%B9%98%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80)를 생성하여 해당 branch에서 작업 및 테스팅을 수행합니다.
```text
$ cd hamonize
$ git checkout -b myfeature
```

**4. Commit**

* 수정 사항을 [commit](https://git-scm.com/book/ko/v2/Git%EC%9D%98-%EA%B8%B0%EC%B4%88-%EC%88%98%EC%A0%95%ED%95%98%EA%B3%A0-%EC%A0%80%EC%9E%A5%EC%86%8C%EC%97%90-%EC%A0%80%EC%9E%A5%ED%95%98%EA%B8%B0)합니다.
```text
$ git commit -a -m '[commit message]'
```

**5. Push**

* 수정 사항을 자신의 GitHub Repository에 Push 합니다.
```text
git push origin myfeature
```

**6. Pull Request 생성하기**

* 자신의 Github Repository에서 수정 및 테스팅이 완료되면, New pull request 버튼을 클릭해 Pull Request를 생성합니다.

* Pull Request를 생성할 때, comment로 해당 이슈가 논의된 위치와 수정된 사항에 대한 설명을 포함해 주세요.

**7. CLA**

* 생성한 Pull Request에 [Contributor License Agreement](https://ko.wikipedia.org/wiki/%EA%B8%B0%EC%97%AC%EC%9E%90_%EB%9D%BC%EC%9D%B4%EC%84%A0%EC%8A%A4_%EB%8F%99%EC%9D%98) 사인 방법을 안내하는 댓글이 생성됩니다.

* 안내에 따라 CLA 사인을 완료하면, Upstream Repository의 관리자가 요청된 Pull Request를 검토할 것입니다.

**8. Feedback**

* 프로젝트 관리자가 Pull Request를 검토한 후, 수정을 요청하거나, 거절하거나, 수락할 것입니다.
</br></br>
