# Start
catalunha@pop-os:~/myapp$ flutter create --project-name=agendarep --org to.brintec --platforms android,web ./agendarep


# Build Web & Deploy


cd ~/myapp/classfrase_bloc && flutter build web --dart-define=keyApplicationId=123 --dart-define=keyClientKey=456  && cd back4app/classfrase/ && b4a deploy

flutter build web  && cd back4app/classfrase/ && b4a deploy