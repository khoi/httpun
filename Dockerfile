FROM swift:3.1

ENV httpun /root/vapor

RUN mkdir $httpun
ADD . $httpun

WORKDIR $httpun

RUN swift build -c debug -C $httpun
RUN swift build -c release -C $httpun
RUN swift test -C $httpun

EXPOSE 8080

CMD ["/root/vapor/.build/release/Run"]
