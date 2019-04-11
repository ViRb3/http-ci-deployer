package main

import (
	"flag"
	"io/ioutil"
	"log"
	"strings"

	"github.com/gin-gonic/gin"
)

func main() {
	port := flag.String("port", "5000", "Port to listen on")
	flag.Parse()

	keyFile, err := ioutil.ReadFile("key.txt")
	key := string(keyFile)
	if err != nil || len(strings.TrimSpace(key)) < 10 {
		panic("bad key")
	}

	router := gin.Default()

	router.POST("/upload/*path", func(c *gin.Context) {
		if key != c.GetHeader("KEY") {
			c.AbortWithStatus(403)
			return
		}
		file, err := c.FormFile("file")
		if err != nil {
			c.AbortWithStatus(400)
			return
		}
		path := c.Param("path")[1:]
		c.SaveUploadedFile(file, path)
		log.Printf("Deployed to: %s", path)
		c.Status(200)
	})

	router.Run(":" + *port)
}
