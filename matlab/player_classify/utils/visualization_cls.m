function visualization_cls(test_data_info,false_neg,false_pos,annot,DataRoot,delay_)
% test_data_info:[idx_in_annot,feature_point_x,feature_point_y]
% annot,DataRoot: find image data location
% delay_:time interval
    assert(size(test_data_info,2) == 3);
    assert(size(false_neg,2) == 3);
    assert(size(false_pos,2) == 3);
    % data format
    vs_im = {};
    MaxImg = max(max(false_neg(:,1)),max(false_pos(:,1)));
    ImgIdxAll = [];
    for i = 1:MaxImg
        idx_fn = find(false_neg(:,1) == i);
        idx_fp = find(false_pos(:,1) == i);
        if ~isempty(idx_fn) || ~isempty(idx_fp)
            vs_im{end+1}.imgPath = annot(i).ImgName;
            vs_im{end}.wrong_fn = false_neg(idx_fn,2:end);
            vs_im{end}.wrong_fp = false_pos(idx_fp,2:end);
            ImgIdxAll(end + 1) = i;
        end
    end

    % point show
    for i = min(test_data_info(:,1)):max(test_data_info(:,1))
        idx = find(test_data_info(:,1) == i);
        if ~isempty(idx)
            Cord=test_data_info(idx,2:3);
            imshow(imread([DataRoot,annot(i).ImgName]));
            title(num2str(i));
            hold on
            plot(Cord(:,1),Cord(:,2),'g*');
            hold on

            idx_vs = find(ImgIdxAll==i);
            % show fn
            if ~isempty(vs_im{idx_vs}.wrong_fn)
                plot(vs_im{idx_vs}.wrong_fn(:,1),vs_im{idx_vs}.wrong_fn(:,2),'r*');
                hold on
            end
            % show fp
            if ~isempty(vs_im{idx_vs}.wrong_fp)
                plot(vs_im{idx_vs}.wrong_fp(:,1),vs_im{idx_vs}.wrong_fp(:,2),'b*');
                hold on
            end
            hold off
            pause(delay_);
        end
    end
end


