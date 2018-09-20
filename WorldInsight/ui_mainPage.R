frontp = function()
  
  div(class = "frontp",
      div(class = "front-banner",
          div(class = "imgcon"),
          img(src ="mainbanner.jpg", height = 225, width = 700, align="center"),
          
          div(class = "hcon", h1("The World Insight"), h1("한국의 무역 흐름도"))
      ),
      tags$p(class = "intro", "2010 ~ 2018년 까지의 수출입 무역 데이터를 기반으로 한 객관적인 통계 어플리케이션 입니다. "),
      div(class = "intro-divider"),
      tags$p(class = "intro", "어플리케이션의 기능"),
      tags$ol(
        tags$li("World map : 지도를 기반으로 한 무역 데이터 시각화"),
        tags$li("Yearly Country Graph : 국가 별 품목별 수출입 데이터 그래프"),
        tags$li("Yearly Product Graph : 품목별 국내 수출입 데이터 그래프"),
        tags$li("Money Flow Chart : 전 세계 국가에 대한 연도 별 수입금액, 수출금액 변화 추이 애니메이션"),
        tags$li("Surplus Table : 무역수지(흑자, 적자)를 구분한 데이터 테이블"),
        tags$li("Top Countries : 품목별 Top5 국가 무역 변화 추이 그래프"), 
        tags$li("Top 10 Products : 국내 수출입 상위 10가지 분야 테이블")
      ),
      tags$p("Developed By Jun Ho Park")
  )
