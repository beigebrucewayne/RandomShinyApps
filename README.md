# Shiny Tips + Tricks

#### add image

- store image in www/
```r
img(src = "myimage.png", height = 72, width = 72)
```

#### tabs -> plain shiny

```r
mainPanel(
    tabsetPanel(
        tabPanel(),
        tabPanel()
    )
)
` ``