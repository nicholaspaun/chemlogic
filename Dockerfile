FROM swipl as builder
WORKDIR /app
COPY . /app
RUN apt update && apt install -y \
 	make \ 
  && rm -rf /var/lib/apt/lists/* \ 
  && make web

FROM swipl
WORKDIR /app
COPY --from=builder /app/bin .
EXPOSE 8000
USER 10001
CMD ["./chemweb"]
