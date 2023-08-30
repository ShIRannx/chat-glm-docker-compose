FROM bitnami/git as GIT
WORKDIR /tmp/git
RUN git clone https://github.com/THUDM/ChatGLM-6B.git

FROM python:3.11 AS PY

COPY --from=GIT /tmp/git/ChatGLM-6B /app

WORKDIR /app
RUN pip install -r requirements.txt -i https://pypi.mirrors.ustc.edu.cn/simple
RUN sed -i '6d' web_demo.py && \
  sed -i '6i\model = AutoModel.from_pretrained("THUDM/chatglm-6b-int4",trust_remote_code=True).float()' web_demo.py

EXPOSE 7860
CMD ["python", "web_demo.py"]
