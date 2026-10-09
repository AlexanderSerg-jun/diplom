# registry.tf

resource "yandex_container_registry" "my_registry" {
  name = "test-app-registry" # Имя реестра
}



# ЕСПЛИ ХОЧЕШЬ ДАТЬ ПРАВА НА РЕЕСТР ТЕКУЩЕМУ SA (tf-admin), КОТОРЫМ ЗАПУСКАЕТСЯ TF:
# (Замени ID на ID твоего tf-admin SA из terraform output или console)

