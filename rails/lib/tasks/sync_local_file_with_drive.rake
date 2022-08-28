namespace :sync_local_file_with_drive do
  desc "sync local file with drive"
  # refs. https://drive.google.com/drive/folders/1MQem2wQ8EhCcmM5oZmTCPsZXhCO-TkRD
  UPDATE_FILE_DATA_SET = [
    ["/app/attachments/5f1ea18c-e14d-42b6-b94d-29c3d1094ba6.bin", "https://drive.google.com/file/d/15Mw0kwjlXgUiFlA5mVVAlmKnNluJJo9A/view?usp=sharing"],
    ["/app/attachments/f58c4470-e358-4a3a-8427-2e840b11b3bd.zip", "https://drive.google.com/file/d/1OE_668dNHS6a-GQClSqmv2oqkT18WMWa/view?usp=sharing"],
    ["/app/attachments/9a84f69d-92cc-4591-a1a8-19501345050a.pptx", "https://docs.google.com/presentation/d/1ex6yLg35i-TEhnPYvJ5m5D6dCOOR7VnA/edit?usp=sharing&ouid=104561979838057235442&rtpof=true&sd=true"],
    ["/app/attachments/a7f68eaf-8113-49e2-b1a7-392b53a68bbc.mov", "https://drive.google.com/file/d/105icOK3CWmHXeULbovs6uVXoze7JtiL-/view?usp=sharing"],
    ["/app/attachments/1d6a5b25-33f9-45b3-8970-d814f2de55e4.pptx", "https://docs.google.com/presentation/d/1zKxDW_ptsNwtIaV7xCNZlSTg7M2oUbwk/edit?usp=sharing&ouid=104561979838057235442&rtpof=true&sd=true"],
    ["/app/attachments/5d6ee717-23a9-4c1e-b67e-28081341f893.pptx", "https://docs.google.com/presentation/d/1BtDO0tlmAkvFC2Xc3g0UTbPwzYQsYt5Q/edit?usp=sharing&ouid=104561979838057235442&rtpof=true&sd=true"],
    ["/app/attachments/10a2d8c5-58dc-474b-8fbd-834de62406f3.mov", "https://drive.google.com/file/d/1xCgIbHGsVJ1Yv6DU0fmonwcWprfI6Dw-/view?usp=sharing"],
    ["/app/attachments/1e286305-5fa7-49a3-8137-298cf6fa754e.mov", "https://drive.google.com/file/d/1aubNl8qM9J1ohz5uB9hFZkwSTzhJX22X/view?usp=sharing"],
    ["/app/attachments/3adf928f-78e8-4ac8-ba84-e1a3f456cb46.mp4", "https://drive.google.com/file/d/16XpjZGwQOf2bm9Kg1wH90EFFUsK3uL7a/view?usp=sharing"],
    ["/app/attachments/ef25a32e-791b-4c26-9d6a-afb88e83d415.mp4", "https://drive.google.com/file/d/1YDm3tRfPAdIM_m4BqdXXBRYxEArU2syc/view?usp=sharing"],
    ["/app/attachments/2b87f50a-8df3-42ea-a6c9-e5302e749b4a.pdf", "https://drive.google.com/file/d/1JN1qzz2Eq7ilNJwYT6uVdo-l4yFpOidf/view?usp=sharing"],
    ["/app/attachments/79ec7b67-c6a1-435b-bb73-81aa3e2154c5.aac", "https://drive.google.com/file/d/1wFlp3uUZnmAwC39Pyp_0CLc1NfW3bsYT/view?usp=sharing"],
    ["/app/attachments/cbeea66c-70c0-47fe-aa13-a01d958934bb.aac", "https://drive.google.com/file/d/1sgVVFATZ12DPWZmOMpE3r75AShLLwo-e/view?usp=sharing"],
    ["/app/attachments/3248ede3-b42e-4ef7-bca6-8d7267fcfa13.aac", "https://drive.google.com/file/d/1otzkFf76r4y9lZJPjMvtJVwnuPkhqiAp/view?usp=sharing"],
    ["/app/attachments/93729641-a909-444e-ab8b-eee875eaee28.mov", "https://drive.google.com/file/d/17Nc_sQT5Rv9TV17n9HSU0SKkv4TDguq0/view?usp=sharing"],
    ["/app/attachments/4b39c7c8-e1c4-4b60-8f17-041de21f16b0.mov", "https://drive.google.com/file/d/15qsj7f42WrKD24Hv32M1TTtEKNJ5jKbe/view?usp=sharing"],
    ["/app/attachments/fd493f42-f6a6-41bf-bcc9-762ff7829bdd.m4a", "https://drive.google.com/file/d/1KrlMLlNpeqfFlFaTchEv2pG7JAa9x6wn/view?usp=sharing"],
    ["/app/attachments/39957fb7-a6db-4aa2-af04-ac3c4096c673.mov", "https://drive.google.com/file/d/14H4hhazEWStSnvr2M4MDQ4DZS5a_NSSG/view?usp=sharing"],
    ["/app/attachments/4c911c03-2282-45d7-ba7a-f3dfdc82d19c.mov", "https://drive.google.com/file/d/1wIBsy8eW2IU03Usvvs0BgBcPluWsAli9/view?usp=sharing"],
    ["/app/attachments/3b5773cd-614c-4516-b320-92b15de87ab1.mov", "https://drive.google.com/file/d/1fUEx4AGqSHOyn_wPuJ9O0ho6emco9Pnl/view?usp=sharing"],
    ["/app/attachments/c7e69f6e-7e2b-4705-ba63-e2aff92583a9.pdf", "https://drive.google.com/file/d/1eNHVgbXspVHwFRkqJRjwNHT5XA3ETYbc/view?usp=sharing"],
    ["/app/attachments/e5fa9117-9602-4f29-8643-b6e6a69532f3.mov", "https://drive.google.com/file/d/1sxQ-lkhP7DX4P55sd_DPWjLrPAP2rHiB/view?usp=sharing"],
    ["/app/attachments/fc241333-4023-4fae-a91c-a8c6686bc48f.mov", "https://drive.google.com/file/d/1y7R254tjMuUlmyfzYafZJGn9_0CqTAu-/view?usp=sharing"],
    ["/app/attachments/4dd63c8a-cac2-4462-b8fc-a8defbdb9a57.mov", "https://drive.google.com/file/d/1-MW_IcieV0DVFu_iyOYUR44Xk1jfmCBR/view?usp=sharing"],
    ["/app/attachments/0835cb9c-57f9-41a1-a75b-ffa0bef98019.mp4", "https://drive.google.com/file/d/1tjv9qEk2lBUxaf_bqKpP_n_gOu94AnwD/view?usp=sharing"],
    ["/app/attachments/f771e0eb-bf50-4f6a-8bcc-03bded98e98c.mov", "https://drive.google.com/file/d/1xj3Ud6XWwJljFL3Z6ZWI-r9UyXvc8Y1n/view?usp=sharing"],
    ["/app/attachments/c35f8fd9-bbe0-4517-b58d-cb5de6b86ae9.mov", "https://drive.google.com/file/d/1YBzgeWFC2JhUHLryuw3GnuXI2_bpva5n/view?usp=sharing"],
    ["/app/attachments/8cf314be-6804-45dd-9918-50f505419786.mp4", "https://drive.google.com/file/d/1SwxlUJ1kF3myGHwVoRCdcTT5haXVJ6G_/view?usp=sharing"]
  ]
  task :execute => :environment do
    p "start"

    ActiveRecord::Base.transaction do
      UPDATE_FILE_DATA_SET.each do |local_path, drive_path|
        AttachimentFile.find_by(local_path: local_path).update!(drive_path: drive_path)
      end
    end

    p "complete"
  end
end
