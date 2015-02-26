
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

  pie_fn=function(sampleid,lv,top){
    z1=ya[[lv]][,c("shortname",sampleid),with=F]
    setnames(z1,c("shortname",sampleid),c("Taxonomy","Reads"))
    z2=z1[,.(Reads=sum(Reads)),by=Taxonomy]
    z2=z2[Reads!=0]
    if(length(z2[Taxonomy=="NA",Taxonomy])==0&nrow(z2)<=top){
      z7=z2[order(Reads,decreasing=T)]
    } else {
      z3=z2[Taxonomy!="NA"]
      z4=z3[order(z3[,Reads],decreasing=T)[1:min(top,nrow(z3))],Taxonomy]
      z2[,top:=ifelse(Taxonomy%chin%z4,1,0)]
      z5=split(z2,z2[,top])
      z5[[1]]=data.table(Taxonomy="Other",Reads=z5[[1]][,sum(Reads)],top=0)
      z6=rbindlist(z5)
      z7=z6[order(Reads,decreasing=T)]
    }
    #Pie1 <- gvisPieChart(z7,labelvar = "Taxonomy", numvar = "Reads",options=list(width="800px", height="400px"))
    #print(Pie1, "chart")
    #return(Pie1)
    return(z7)
  }
  
  output$distPlot1 <- renderPlot({
    
    
    a0=pie_fn(sampleid=input$SampleID,lv=which(lvn==input$TaxoLv),top=10)
    a1=a0[,Reads]
    names(a1)=a0[,Taxonomy]
    pie(a1)

    
  })

  output$distPlot2 <- renderPlot({
    
    
    a0=pie_fn(sampleid=input$SampleID,lv=which(lvn==input$TaxoLv),top=10)
    a0$pct=a0$Reads/sum(a0$Reads)*100
    pie=ggplot(a0,
               aes(x = 1,y = pct, fill = Taxonomy) ) +
      geom_bar(width = 2,stat="identity") +
      coord_polar(theta = "y") +
      scale_x_discrete("")
    print(pie)
    
  })
  
  output$gvis <- renderGvis({
    
    
    a0=pie_fn(sampleid=input$SampleID,lv=which(lvn==input$TaxoLv),top=10)
    gvisPieChart(a0,labelvar = "Taxonomy", numvar = "Reads",options=list(width="800px", height="400px"))
    
  })
  
})
